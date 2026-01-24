import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/report.dart';
import 'package:fire_alarm_system/models/signature.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/models/visit_report_data.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:fire_alarm_system/models/contract_data.dart';
import 'package:fire_alarm_system/models/emergency_visit.dart';

class ReportsRepository {
  final FirebaseFirestore _firestore;
  final AppRepository appRepository;
  QuerySnapshot? contractsSnapshot;
  QuerySnapshot? signaturesSnapshot;
  QuerySnapshot? visitReportsSnapshot;
  QuerySnapshot? reportsMetaDataSnapshot;
  QuerySnapshot? emergencyVisitsSnapshot;
  List<ContractComponent>? _contractComponents;
  List<ContractCategory>? _contractCategories;
  List<ContractData>? _contracts;
  List<SignatureData> _signatures = [];
  List<VisitReportData> _visitReports = [];
  List<EmergencyVisitData> _emergencyVisits = [];

  ReportsRepository({required this.appRepository})
      : _firestore = FirebaseFirestore.instance;

  List<ContractComponent>? get contractComponents => _contractComponents;
  List<ContractCategory>? get contractCategories => _contractCategories;
  List<ContractData>? get contracts => _contracts;
  List<VisitReportData>? get visitReports => _visitReports;
  List<EmergencyVisitData>? get emergencyVisits => _emergencyVisits;

  void refresh() {
    _getMetaData();
    _getSignatures();
    _getContracts();
    _getVisitReports();
    _getEmergencyVisits();
  }

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
        contract.sharedWith = [
          contract.metaData.employee?.info.id ?? '',
          contract.metaData.client?.info.id ?? ''
        ];
        txn.set(docRef, {
          ...contract.toJson(),
          'createdAt': FieldValue.serverTimestamp(),
        });
        return docRef.id;
      });
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> saveVisitReport(VisitReportData visitReport) async {
    try {
      return await _firestore.runTransaction((txn) async {
        final maxRef = _firestore.collection('info').doc('maxVisitReportCode');
        final maxSnap = await txn.get(maxRef);
        int current = 0;
        if (maxSnap.exists) {
          final data = maxSnap.data() as Map<String, dynamic>;
          current = int.tryParse((data['value'] ?? '0').toString()) ?? 0;
        }
        final next = current + 1;
        txn.set(maxRef, {'value': next}, SetOptions(merge: true));
        visitReport.code = next;
        final docRef = _firestore.collection('visitReports').doc();
        visitReport.id = docRef.id;
        visitReport.sharedWith = [
          visitReport.contractMetaData.employee?.info.id ?? '',
          visitReport.contractMetaData.client?.info.id ?? ''
        ];
        txn.set(docRef, {
          ...visitReport.toJson(),
          'createdAt': FieldValue.serverTimestamp(),
        });
        return docRef.id;
      });
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> requestEmergencyVisit(
      {required String contractId, required String description}) async {
    try {
      final contract =
          _contracts?.firstWhere((c) => c.metaData.id == contractId);
      if (contract == null) {
        throw Exception('contract_not_found');
      }
      final companyId = contract.metaData.employee?.branch.company.id ?? '';
      final branchId = contract.metaData.employee?.branch.id ?? '';
      if (companyId.isEmpty || branchId.isEmpty) {
        throw Exception('missing_contract_company_or_branch');
      }
      return await _firestore.runTransaction((txn) async {
        final maxRef =
            _firestore.collection('info').doc('maxEmergencyVisitCode');
        final maxSnap = await txn.get(maxRef);
        int current = 0;
        if (maxSnap.exists) {
          final data = maxSnap.data() as Map<String, dynamic>;
          current = int.tryParse((data['value'] ?? '0').toString()) ?? 0;
        }
        final next = current + 1;
        txn.set(maxRef, {'value': next}, SetOptions(merge: true));
        final docRef = _firestore.collection('emergencyVisits').doc();
        final id = docRef.id;
        final now = Timestamp.now();
        final emergencyVisit = EmergencyVisitData(
          id: id,
          code: next,
          companyId: companyId,
          branchId: branchId,
          contractId: contractId,
          requestedBy: appRepository.userInfo.id,
          description: description,
          comments: [
            CommentData(
              userId: appRepository.userInfo.id,
              comment: description,
              createdAt: now,
              oldStatus: EmergencyVisitStatus.pending,
              newStatus: EmergencyVisitStatus.pending,
            ),
          ],
          status: EmergencyVisitStatus.pending,
          createdAt: now,
        );
        txn.set(docRef, emergencyVisit.toMap());
        return docRef.id;
      });
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addEmergencyVisitComment({
    required String emergencyVisitId,
    required String comment,
  }) async {
    try {
      final trimmed = comment.trim();
      if (trimmed.isEmpty) return;

      final emergencyVisit =
          _emergencyVisits.firstWhere((e) => e.id == emergencyVisitId);
      final newComment = CommentData(
        userId: appRepository.userInfo.id,
        comment: trimmed,
        createdAt: Timestamp.now(),
        oldStatus: emergencyVisit.status,
        newStatus: emergencyVisit.status,
      );
      await _firestore
          .collection('emergencyVisits')
          .doc(emergencyVisitId)
          .update({
        // Keep list as a pure List<Map<String, dynamic>> for Firestore.
        'comments': [
          ...emergencyVisit.comments.map((c) => c.toMap()),
          newComment.toMap(),
        ],
      });
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> changeEmergencyVisitStatus({
    required String emergencyVisitId,
    required EmergencyVisitStatus newStatus,
  }) async {
    final userId = appRepository.userInfo.id;
    try {
      final docRef =
          _firestore.collection('emergencyVisits').doc(emergencyVisitId);
      await _firestore.runTransaction((txn) async {
        final snap = await txn.get(docRef);
        if (!snap.exists) throw Exception('emergency_visit_not_found');
        final data = snap.data() ?? <String, dynamic>{};

        final statusStr =
            data['status']?.toString() ?? EmergencyVisitStatus.pending.name;
        final oldStatus = EmergencyVisitStatus.values.firstWhere(
          (e) => e.name == statusStr,
          orElse: () => EmergencyVisitStatus.pending,
        );
        if (oldStatus == newStatus) {
          throw Exception('invalid_status_transition');
        }

        final requestedBy = data['requestedBy']?.toString() ?? '';
        final contractId = data['contractId']?.toString() ?? '';

        ContractData? contract;
        try {
          contract = _contracts?.firstWhere((c) => c.metaData.id == contractId);
        } catch (_) {
          contract = null;
        }
        final contractEmployeeId = contract?.metaData.employeeId ??
            contract?.metaData.employee?.info.id ??
            '';
        final sharedWith = (contract?.sharedWith ?? const <dynamic>[])
            .map((e) => e.toString())
            .toList();

        final bool isRequester = userId.isNotEmpty && userId == requestedBy;
        final bool isEmployee = appRepository.userRole is Employee;
        final bool isContractEmployee =
            isEmployee && userId.isNotEmpty && userId == contractEmployeeId;
        final bool isSharedEmployee =
            isEmployee && userId.isNotEmpty && sharedWith.contains(userId);

        bool allowed = false;

        // (1) Requester transitions
        if (isRequester) {
          allowed = (oldStatus == EmergencyVisitStatus.pending &&
                  newStatus == EmergencyVisitStatus.cancelled) ||
              (oldStatus == EmergencyVisitStatus.rejected &&
                  newStatus == EmergencyVisitStatus.cancelled);
        }

        // (2) Employee transitions (contract employee OR employee in sharedWith)
        if (!allowed && (isContractEmployee || isSharedEmployee)) {
          allowed = (oldStatus == EmergencyVisitStatus.pending &&
                  (newStatus == EmergencyVisitStatus.approved ||
                      newStatus == EmergencyVisitStatus.rejected)) ||
              (oldStatus == EmergencyVisitStatus.approved &&
                  newStatus == EmergencyVisitStatus.completed);
        }

        if (!allowed) {
          throw Exception('unauthorized_status_change');
        }

        final existingComments = List.from(data['comments'] ?? const []);
        existingComments.add({
          'userId': userId,
          'comment': '',
          'createdAt': Timestamp.now(),
          'oldStatus': oldStatus.name,
          'newStatus': newStatus.name,
        });

        txn.update(docRef, {
          'status': newStatus.name,
          'comments': existingComments,
        });
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
        'companyId': contract.metaData.employee?.branch.company.id,
        'branchId': contract.metaData.employee?.branch.id,
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

  Future<VisitReportData> signVisitReport({
    required dynamic user,
    required VisitReportData visitReport,
  }) async {
    final bool isClient = user is Client;
    final bool isEmployee = user is Employee;
    VisitReportData signedVisitReport = visitReport;
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
      final String visitReportCode = (visitReport.code ?? '').toString();
      final String prefix = isClient ? 'VC' : 'VE';
      final String name =
          '$prefix-$dd$mm$yyyy-$userCode-$visitReportCode-$next';
      final sigRef = _firestore.collection('signatures').doc();
      txn.set(sigRef, {
        'code': next,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': appRepository.userInfo.id,
        'visitReportId': visitReport.id,
        'companyId': visitReport.contractMetaData.employee?.branch.company.id,
        'branchId': visitReport.contractMetaData.employee?.branch.id,
      });
      final visitReportRef =
          _firestore.collection('visitReports').doc(visitReport.id);
      if (isClient) {
        txn.update(visitReportRef, {'clientSignatureId': sigRef.id});
        signedVisitReport.clientSignature.id = sigRef.id;
      } else {
        txn.update(visitReportRef, {'employeeSignatureId': sigRef.id});
        signedVisitReport.employeeSignature.id = sigRef.id;
      }
    });
    return signedVisitReport;
  }

  void _getMetaData() {
    if (reportsMetaDataSnapshot == null) {
      _contractCategories = [];
      _contractComponents = [];
      return;
    }
    final contractComponentsData = reportsMetaDataSnapshot?.docs
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

    final contractCategoriesData = reportsMetaDataSnapshot?.docs
        .firstWhere((doc) => doc.id == 'contractComponentCategories')
        .data() as Map<String, dynamic>;
    _contractCategories = List.from(contractCategoriesData['categories'] ?? [])
        .whereType<Map>()
        .map((e) => ContractCategory(
              arName: (e['arName'] ?? '').toString(),
              enName: (e['enName'] ?? '').toString(),
            ))
        .toList();
    _contractCategories!
        .insert(0, ContractCategory(arName: 'أخرى', enName: 'Other'));
  }

  void _getSignatures() {
    if (signaturesSnapshot == null) {
      _signatures = [];
      return;
    }
    _signatures = signaturesSnapshot!.docs.map((doc) {
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
    if (contractsSnapshot == null) {
      _contracts = [];
      return;
    }
    _contracts = contractsSnapshot!.docs.map((doc) {
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
        contract.sharedWithClients = [];
        contract.sharedWithEmployees = [];
        for (var sharedWith in contract.sharedWith) {
          try {
            contract.sharedWithEmployees.add(appRepository.users.employees
                .firstWhere((e) => e.info.id == sharedWith));
          } catch (_) {
            try {
              contract.sharedWithClients.add(appRepository.users.clients
                  .firstWhere((e) => e.info.id == sharedWith));
            } catch (_) {}
          }
        }
      } catch (_) {}
      contract.metaData.id ??= doc.id;
      return contract;
    }).toList();
  }

  void _getVisitReports() {
    if (visitReportsSnapshot == null) {
      _visitReports = [];
      return;
    }
    _visitReports = visitReportsSnapshot!.docs
        .map((doc) {
          final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          final visitReport = VisitReportData.fromJson(data);
          visitReport.id ??= doc.id;
          try {
            visitReport.employeeSignature = _signatures
                .firstWhere((s) => s.id == visitReport.employeeSignature.id);
          } catch (_) {
            visitReport.employeeSignature = SignatureData();
          }
          try {
            visitReport.clientSignature = _signatures
                .firstWhere((s) => s.id == visitReport.clientSignature.id);
          } catch (_) {
            visitReport.clientSignature = SignatureData();
          }
          try {
            visitReport.contractMetaData = _contracts!
                .firstWhere((c) => c.metaData.id == visitReport.contractId)
                .metaData;
            return visitReport;
          } catch (_) {
            visitReport.contractMetaData = ContractMetaData();
            return null;
          }
        })
        .whereType<VisitReportData>()
        .toList();
  }

  void _getEmergencyVisits() {
    if (emergencyVisitsSnapshot == null) {
      _emergencyVisits = [];
      return;
    }
    _emergencyVisits = emergencyVisitsSnapshot!.docs
        .map((doc) {
          final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          final emergencyVisit = EmergencyVisitData.fromMap(data);
          try {
            _contracts!
                .firstWhere((c) => c.metaData.id == emergencyVisit.contractId);
            return emergencyVisit;
          } catch (_) {
            return null;
          }
        })
        .whereType<EmergencyVisitData>()
        .toList();
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

  Future<void> setSharedWith(String contractId, List<String> sharedWith) async {
    try {
      final contracts = _firestore.collection('contracts');

      await _firestore.runTransaction((txn) async {
        final contractRef = contracts.doc(contractId);

        final existingReports = <DocumentSnapshot>[];
        for (final ref in visitReportsSnapshot!.docs) {
          if ((ref.data()! as Map<String, dynamic>)['contractId']?.toString() ==
              contractId) {
            existingReports.add(ref);
          }
        }

        txn.update(contractRef, {
          'sharedWith': sharedWith,
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        for (final snap in existingReports) {
          if (!snap.exists) continue;
          txn.update(snap.reference, {
            'sharedWith': sharedWith,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  SignatureData? validateSignature(String name) {
    final signatures = _signatures.where((s) => s.name == name).toList();
    if (signatures.length != 1) {
      return null;
    }
    return signatures.first;
  }

  VisitReportData? getVisitReport(String id) {
    try {
      return _visitReports.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  ContractData? getContract(String id) {
    try {
      return _contracts?.firstWhere((c) => c.metaData.id == id);
    } catch (_) {
      return null;
    }
  }
}
