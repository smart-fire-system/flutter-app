import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/report.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:fire_alarm_system/models/contract_data.dart';

class ReportsRepository {
  final FirebaseFirestore _firestore;
  final AppRepository appRepository;
  final _refreshController = StreamController<void>.broadcast();
  QuerySnapshot? _contractsSnapshot;
  QuerySnapshot? _signaturesSnapshot;
  QuerySnapshot? _reportsMetaDataSnapshot;
  List<ContractComponent>? _contractComponents;
  List<ContractCategory>? _contractCategories;
  List<ContractData>? _contracts;
  List<ContractData>? _filteredContracts;
  List<SignatureData> _signatures = [];

  ReportsRepository({required this.appRepository})
      : _firestore = FirebaseFirestore.instance {
    _refresh();

    appRepository.branchesAndCompaniesStream.listen((status) {
      _refresh();
    });

    appRepository.usersStream.listen((status) {
      _refresh();
    });

    appRepository.authStateStream.listen((status) {
      _refresh();
    });

    _firestore.collection('reportsMetaData').snapshots().listen((snapshot) {
      _reportsMetaDataSnapshot = snapshot;
      _contractCategories = [];
      _contractComponents = [];
      _refresh();
    });

    _firestore.collection('contracts').snapshots().listen((snapshot) {
      _contractsSnapshot = snapshot;
      _contracts = [];
      _filteredContracts = [];
      _refresh();
    });

    _firestore.collection('signatures').snapshots().listen((snapshot) {
      _signaturesSnapshot = snapshot;
      _signatures = [];
      _refresh();
    });
  }

  List<ContractComponent>? get contractComponents => _contractComponents;
  List<ContractCategory>? get contractCategories => _contractCategories;
  List<ContractData>? get contracts => _contracts;
  List<ContractData>? get filteredContracts => _filteredContracts;
  Stream<void> get refreshStream => _refreshController.stream;

  Future<void> saveContractComponents(
      List<ContractComponent> components) async {
    try {
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
      final maxRef = _firestore.collection('info').doc('maxSignatureCode');
      final maxSnap = await txn.get(maxRef);
      int current = 0;
      if (maxSnap.exists) {
        final data = maxSnap.data() as Map<String, dynamic>;
        current = int.tryParse((data['value'] ?? '0').toString()) ?? 0;
      }
      final next = current + 1;
      txn.set(maxRef, {'value': next}, SetOptions(merge: true));
      final DateTime now = DateTime.now();
      final String dd = now.day.toString().padLeft(2, '0');
      final String mm = now.month.toString().padLeft(2, '0');
      final String yyyy = now.year.toString();
      final int userCode = appRepository.userInfo.code;
      final String contractCode = (contract.metaData.code ?? '').toString();
      final String prefix = isClient ? 'CC' : 'CE';
      final String name = '$prefix-$dd$mm$yyyy-$userCode-$contractCode-$next';
      final sigRef = _firestore.collection('signatures').doc();
      txn.set(sigRef, {
        'code': next,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': appRepository.userInfo.id,
        'contractId': contract.metaData.id,
      });
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

  void _refresh() {
    _getMetaData();
    _getSignatures();
    _getContracts();
    _filterContracts();
    _refreshController.add(null);
  }

  void _getMetaData() {
    if (_reportsMetaDataSnapshot == null) {
      _contractCategories = [];
      _contractComponents = [];
      return;
    }
    final contractComponentsData = _reportsMetaDataSnapshot?.docs
        .firstWhere((doc) => doc.id == 'contractComponents')
        .data() as Map<String, dynamic>;
    _contractComponents = List.from(contractComponentsData['items'] ?? [])
        .whereType<Map>()
        .map((e) => ContractComponent(
              arName: (e['arName'] ?? '').toString(),
              enName: (e['enName'] ?? '').toString(),
              description: (e['description'] ?? '').toString(),
              categoryIndex:
                  int.tryParse((e['categoryIndex'] ?? '0').toString()) ?? 0,
            ))
        .toList();

    final contractCategoriesData = _reportsMetaDataSnapshot?.docs
        .firstWhere((doc) => doc.id == 'contractComponentCategories')
        .data() as Map<String, dynamic>;
    _contractCategories = List.from(contractCategoriesData['categories'] ?? [])
        .whereType<Map>()
        .map((e) => ContractCategory(
              arName: (e['arName'] ?? '').toString(),
              enName: (e['enName'] ?? '').toString(),
            ))
        .toList();
    _contractCategories!.insert(
        0, ContractCategory(arName: 'أخرى', enName: 'Other'));
  }

  void _getSignatures() {
    if (_signaturesSnapshot == null) {
      _signatures = [];
      return;
    }
    _signatures = _signaturesSnapshot!.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
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
  }

  void _getContracts() {
    if (_contractsSnapshot == null) {
      _contracts = [];
      return;
    }
    _contracts = _contractsSnapshot!.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      final contract = ContractData.fromJson(data);
      try {
        contract.metaData.employee = appRepository.users.employees
            .firstWhere((c) => c.info.id == contract.metaData.employeeId);
        contract.metaData.client = appRepository.users.clients
            .firstWhere((c) => c.info.id == contract.metaData.clientId);
        try {
          contract.metaData.employeeSignature = _signatures.firstWhere(
              (s) => s.id == contract.metaData.employeeSignature.id);
        } catch (_) {
          contract.metaData.employeeSignature = SignatureData();
        }
        try {
          contract.metaData.clientSignature = _signatures
              .firstWhere((s) => s.id == contract.metaData.clientSignature.id);
        } catch (_) {
          contract.metaData.clientSignature = SignatureData();
        }
      } catch (_) {}
      contract.metaData.id ??= doc.id;
      return contract;
    }).toList();
  }

  void _filterContracts() {
    if (_contracts == null) {
      _filteredContracts = null;
      return;
    }
    _filteredContracts = [];
    for (final ContractData contract in _contracts ?? []) {
      final Employee? employee = contract.metaData.employee;
      final Client? client = contract.metaData.client;
      bool include = true;
      switch (appRepository.userRole) {
        case MasterAdmin():
        case Admin():
          include = true;
          break;
        case CompanyManager():
          include =
              employee?.branch.company.id == appRepository.userRole.company.id;
          break;
        case BranchManager():
          include = employee?.branch.id == appRepository.userRole.branch.id;
          break;
        case Employee():
          include = employee?.info.id == appRepository.userRole.info.id;
          break;
        case Client():
          include = client?.info.id == appRepository.userRole.info.id;
          break;
        default:
          include = false;
      }
      if (include) {
        _filteredContracts!.add(contract);
      }
    }
  }

  Future<void> setFirstPartyInformation(ContractFirstParty firstParty) async {
    if (appRepository.userRole is! BranchManager) {
      throw Exception('unauthorized');
    }
    try {
      await _firestore
          .collection('branches')
          .doc(appRepository.userRole.branch.id)
          .update(firstParty.toMap());
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }
}
