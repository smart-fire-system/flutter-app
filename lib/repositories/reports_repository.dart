import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/report.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:fire_alarm_system/models/contract_data.dart';

class ReportsRepository {
  final FirebaseFirestore _firestore;
  final AppRepository appRepository;
  ReportsRepository({required this.appRepository})
      : _firestore = FirebaseFirestore.instance;

  Future<List<ContractComponentItem>> readContractComponents() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('reportsMetaData')
          .doc('contractComponents')
          .get();

      if (!snapshot.exists) return [];

      final Map<String, dynamic>? data = snapshot.data();
      if (data == null) return [];

      final List<dynamic> rawItems = List.from(data['items'] ?? []);
      return rawItems
          .whereType<Map>()
          .map((e) => ContractComponentItem(
                arName: (e['arName'] ?? '').toString(),
                enName: (e['enName'] ?? '').toString(),
                description: (e['description'] ?? '').toString(),
                categoryIndex:
                    int.tryParse((e['categoryIndex'] ?? '0').toString()) ?? 0,
              ))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ContractComponentCategory>>
      readContractComponentsCategories() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('reportsMetaData')
          .doc('contractComponentCategories')
          .get();

      if (!snapshot.exists) return [];

      final Map<String, dynamic>? data = snapshot.data();
      if (data == null) return [];

      final List<dynamic> rawItems = List.from(data['categories'] ?? []);
      final List<ContractComponentCategory> categories = [
        ContractComponentCategory(
          arName: 'أخرى',
          enName: 'Other',
        )
      ];
      categories.addAll(rawItems
          .whereType<Map>()
          .map((e) => ContractComponentCategory(
                arName: (e['arName'] ?? '').toString(),
                enName: (e['enName'] ?? '').toString(),
              ))
          .toList());
      return categories;
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> setContractComponents(
      List<ContractComponentItem> components) async {
    try {
      // Ensure items have required keys as strings
      final List<Map<String, String>> sanitized = components
          .map((e) => {
                'arName': e.arName,
                'enName': e.enName,
                'description': e.description,
                'categoryIndex': e.categoryIndex.toString(),
              })
          .toList();

      await _firestore
          .collection('reportsMetaData')
          .doc('contractComponents')
          .set({'items': sanitized});
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> saveContract(ContractData contract) async {
    try {
      contract.metaData.state = ContractState.draft;
      return await _firestore.runTransaction((txn) async {
        final maxRef = _firestore.collection('info').doc('maxContractCode');
        final maxSnap = await txn.get(maxRef);
        int current = 0;
        if (maxSnap.exists) {
          final data = maxSnap.data() as Map<String, dynamic>;
          current = int.tryParse((data['value'] ?? '0').toString()) ?? 0;
        }
        final next = current + 1;
        txn.set(maxRef, {'value': next}, SetOptions(merge: true));

        // assign code into contract
        contract.metaData.code = next;

        final docRef = _firestore.collection('contracts').doc();
        contract.metaData.id = docRef.id;
        txn.set(docRef, contract.toJson());
        return docRef.id;
      });
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ContractData>> readContracts() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('contracts').get();
      final QuerySnapshot<Map<String, dynamic>> signaturesSnapshot =
          await _firestore.collection('signatures').get();
      final List<SignatureData> signatures = signaturesSnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data();
        SignatureData signature = SignatureData.fromJson(data);
        signature.id = doc.id;
        try {
          signature.user = appRepository.users.allUsers
              .firstWhere((u) => u.id == signature.userId);
        } catch (_) {
          signature.user = null;
        }
        return signature;
      }).toList();
      final contracts = snapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data();
        final contract = ContractData.fromJson(data);
        try {
          contract.metaData.employee = appRepository.users.employees
              .firstWhere((c) => c.info.id == contract.metaData.employeeId);
          contract.metaData.client = appRepository.users.clients
              .firstWhere((c) => c.info.id == contract.metaData.clientId);
          try {
            contract.metaData.employeeSignature = signatures.firstWhere(
                (s) => s.id == contract.metaData.employeeSignature.id);
          } catch (_) {
            contract.metaData.employeeSignature = SignatureData();
          }
          try {
            contract.metaData.clientSignature = signatures.firstWhere(
                (s) => s.id == contract.metaData.clientSignature.id);
          } catch (_) {
            contract.metaData.clientSignature = SignatureData();
          }
        } catch (_) {}
        contract.metaData.id ??= doc.id;
        return contract;
      }).toList();
      return filterContracts(contracts);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  List<ContractData> filterContracts(List<ContractData> contracts) {
    final List<ContractData> filtered = [];
    final dynamic user = appRepository.userRole;
    for (final ContractData contract in contracts) {
      final Employee? employee = contract.metaData.employee;
      final Client? client = contract.metaData.client;

      bool include = true;
      switch (user) {
        case MasterAdmin():
        case Admin():
          include = true;
          break;
        case CompanyManager():
          include = employee?.branch.company.id == user.company.id;
          break;
        case BranchManager():
          include = employee?.branch.id == user.branch.id;
          break;
        case Employee():
          include = employee?.info.id == user.info.id;
          break;
        case Client():
          include = client?.info.id == user.info.id;
          break;
        default:
          include = false;
      }

      if (include) {
        filtered.add(contract);
      }
    }
    return filtered;
  }

  Future<ContractData> signContract({
    required dynamic user,
    required ContractData contract,
  }) async {
    final bool isClient = user is Client;
    final bool isEmployee = user is Employee;
    ContractData signedContract = contract;
    if (!isClient && !isEmployee) {
      throw Exception('Unsupported signer');
    }

    await _firestore.runTransaction((txn) async {
      // Read/increment maxSignatureCode
      final maxRef = _firestore.collection('info').doc('maxSignatureCode');
      final maxSnap = await txn.get(maxRef);
      int current = 0;
      if (maxSnap.exists) {
        final data = maxSnap.data() as Map<String, dynamic>;
        current = int.tryParse((data['value'] ?? '0').toString()) ?? 0;
      }
      final next = current + 1;
      txn.set(maxRef, {'value': next}, SetOptions(merge: true));

      // Build signature name
      final DateTime now = DateTime.now();
      final String dd = now.day.toString().padLeft(2, '0');
      final String mm = now.month.toString().padLeft(2, '0');
      final String yyyy = now.year.toString();
      final int userCode = appRepository.userInfo.code;
      final String contractCode = (contract.metaData.code ?? '').toString();
      final String prefix = isClient ? 'CC' : 'CE';
      final String name = '$prefix-$dd$mm$yyyy-$userCode-$contractCode-$next';

      // Create signature doc
      final sigRef = _firestore.collection('signatures').doc();
      txn.set(sigRef, {
        'code': next,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': appRepository.userInfo.id,
        'contractId': contract.metaData.id,
      });

      // Update contract with signature id
      final contractRef =
          _firestore.collection('contracts').doc(contract.metaData.id);
      if (isClient) {
        txn.update(contractRef, {
          'metaData.clientSignatureId': sigRef.id,
          'metaData.state': 'active'
        });
        signedContract.metaData.clientSignature.id = sigRef.id;
        signedContract.metaData.state = ContractState.active;
      } else {
        txn.update(contractRef, {
          'metaData.employeeSignatureId': sigRef.id,
          'metaData.state': 'pendingClient'
        });
        signedContract.metaData.employeeSignature.id = sigRef.id;
        signedContract.metaData.state = ContractState.pendingClient;
      }
    });
    return signedContract;
  }
}
