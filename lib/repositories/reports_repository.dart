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
      final contracts = snapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data();
        final contract = ContractData.fromJson(data);
        try {
          contract.metaData.employee = appRepository.users.employees
              .firstWhere((c) => c.info.id == contract.metaData.employeeId);
          contract.metaData.client = appRepository.users.clients
              .firstWhere((c) => c.info.id == contract.metaData.clientId);
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
    for (var contract in contracts) {
      dynamic user = appRepository.userRole;
      Employee employee = contract.metaData.employee!;
      Client client = contract.metaData.client!;
      switch (user) {
        case MasterAdmin():
        case Admin():
          break;
        case CompanyManager():
          if (employee.branch.company.id != user.company.id) {
            contracts.remove(contract);
            continue;
          }
          break;
        case BranchManager():
          if (employee.branch.id != user.branch.id) {
            contracts.remove(contract);
            continue;
          }
          break;
        case Employee():
          if (employee.info.id != user.info.id) {
            contracts.remove(contract);
            continue;
          }
          break;
        case Client():
          if (client.info.id != user.info.id) {
            contracts.remove(contract);
            continue;
          }
          break;
        default:
          contracts.remove(contract);
          continue;
      }
    }
    return contracts;
  }
}
