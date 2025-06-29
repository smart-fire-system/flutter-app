import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/permissions.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class UserRepository {
  final FirebaseFirestore _firestore;
  QuerySnapshot? usersSnapshot;
  QuerySnapshot? masterAdminsSnapshot;
  QuerySnapshot? adminsSnapshot;
  QuerySnapshot? companyManagersSnapshot;
  QuerySnapshot? branchManagersSnapshot;
  QuerySnapshot? employeesSnapshot;
  QuerySnapshot? clientsSnapshot;
  final AppRepository appRepository;
  UserRepository({required this.appRepository})
      : _firestore = FirebaseFirestore.instance;

  Future<void> updateInformation(
      {required String name,
      required String countryCode,
      required String phoneNumber}) async {
    firebase.User? firebaseUser = firebase.FirebaseAuth.instance.currentUser;
    Map<String, dynamic> userData = {
      'name': name,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
    };
    await firebaseUser!.updateDisplayName(name);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .update(userData);
  }

  Future<void> addUserPermissions({
    required String userId,
    required AppPermissions permissions,
    String companyId = '',
    String branchId = '',
  }) async {
    try {
      if (permissions.role == UserRole.masterAdmin) {
        await _firestore.collection('masterAdmins').doc(userId).set({});
      } else if (permissions.role == UserRole.admin) {
        await _firestore
            .collection('admins')
            .doc(userId)
            .set(AppPermissions().toAdminMap(permissions));
      } else if (permissions.role == UserRole.companyManager) {
        await _firestore
            .collection('companyManagers')
            .doc(userId)
            .set(AppPermissions().toCompanyManagerMap(permissions, companyId));
      } else if (permissions.role == UserRole.branchManager) {
        await _firestore
            .collection('branchManagers')
            .doc(userId)
            .set(AppPermissions().toBranchManagerMap(permissions, branchId));
      } else if (permissions.role == UserRole.employee) {
        await _firestore
            .collection('employees')
            .doc(userId)
            .set(AppPermissions().toEmployeeMap(permissions, branchId));
      } else if (permissions.role == UserRole.client) {
        await _firestore
            .collection('clients')
            .doc(userId)
            .set(AppPermissions().toClientMap(permissions, branchId));
      }
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<void> modifyUserPermissions({
    required String userId,
    required AppPermissions permissions,
    String companyId = '',
    String branchId = '',
  }) async {
    try {
      if (permissions.role == UserRole.admin) {
        await _firestore
            .collection('admins')
            .doc(userId)
            .update(AppPermissions().toAdminMap(permissions));
      } else if (permissions.role == UserRole.companyManager) {
        await _firestore.collection('companyManagers').doc(userId).update(
              AppPermissions().toCompanyManagerMap(permissions, companyId),
            );
      } else if (permissions.role == UserRole.branchManager) {
        await _firestore.collection('branchManagers').doc(userId).update(
              AppPermissions().toBranchManagerMap(permissions, branchId),
            );
      } else if (permissions.role == UserRole.employee) {
        await _firestore.collection('employees').doc(userId).update(
              AppPermissions().toEmployeeMap(permissions, branchId),
            );
      } else if (permissions.role == UserRole.client) {
        await _firestore.collection('clients').doc(userId).update(
              AppPermissions().toClientMap(permissions, branchId),
            );
      }
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<void> deleteUserPermissions({
    required String userId,
    required UserRole userRole,
  }) async {
    try {
      await _firestore
          .collection('${UserInfo.getRoleId(userRole)}s')
          .doc(userId)
          .delete();
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Users getAllUsers() {
    Users users = Users();
    try {
      for (var doc in usersSnapshot!.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        if (masterAdminsSnapshot != null &&
            isMasterAdmin(doc.id, masterAdminsSnapshot!)) {
          if (appRepository.userRole is MasterAdmin) {
            users.masterAdmins.add(
              MasterAdmin(
                info: UserInfo.fromMap(
                  userData,
                  doc.id,
                ),
              ),
            );
          }
          continue;
        }

        if (adminsSnapshot != null) {
          final permissions = isAdmin(doc.id, adminsSnapshot!);
          if (permissions != null) {
            if (appRepository.userRole.permissions.canViewAdmins) {
              users.admins.add(
                Admin(
                  permissions: permissions,
                  info: UserInfo.fromMap(
                    userData,
                    doc.id,
                  ),
                ),
              );
            }
            continue;
          }
        }

        if (companyManagersSnapshot != null) {
          final companyManager = isCompanyManager(
            doc.id,
            companyManagersSnapshot!,
          );
          if (companyManager != null) {
            Company? company = Company.getCompany(
              companyManager['id'],
              appRepository.companies,
            );
            if (company != null) {
              if (appRepository.userRole.permissions.canViewCompanyManagers) {
                users.companyManagers.add(
                  CompanyManager(
                    company: company,
                    branches: Company.getBranches(
                        company.id!, appRepository.branches),
                    permissions: companyManager['permissions'],
                    info: UserInfo.fromMap(
                      userData,
                      doc.id,
                    ),
                  ),
                );
              }
              continue;
            }
          }
        }

        if (branchManagersSnapshot != null) {
          final branchManager = isBranchManager(
            doc.id,
            branchManagersSnapshot!,
          );
          if (branchManager != null) {
            Branch? branch = Branch.getBranch(
              branchManager['id'],
              appRepository.branches,
            );
            if (branch != null) {
              if (appRepository.userRole.permissions.canViewBranchManagers &&
                  (appRepository.userRole is MasterAdmin ||
                      appRepository.userRole is Admin ||
                      (appRepository.userRole is CompanyManager &&
                          appRepository.userRole.company.id ==
                              branch.company.id))) {
                users.branchManagers.add(
                  BranchManager(
                    branch: branch,
                    permissions: branchManager['permissions'],
                    info: UserInfo.fromMap(
                      userData,
                      doc.id,
                    ),
                  ),
                );
              }
              continue;
            }
          }
        }

        if (employeesSnapshot != null) {
          final employee = isEmployee(
            doc.id,
            employeesSnapshot!,
          );
          if (employee != null) {
            Branch? branch = Branch.getBranch(
              employee['id'],
              appRepository.branches,
            );
            if (branch != null) {
              if (appRepository.userRole.permissions.canViewEmployees &&
                  (appRepository.userRole is MasterAdmin ||
                      appRepository.userRole is Admin ||
                      (appRepository.userRole is CompanyManager &&
                          appRepository.userRole.company.id ==
                              branch.company.id) ||
                      (appRepository.userRole is BranchManager &&
                          appRepository.userRole.branch.id == branch.id))) {
                users.employees.add(
                  Employee(
                    branch: branch,
                    permissions: employee['permissions'],
                    info: UserInfo.fromMap(
                      userData,
                      doc.id,
                    ),
                  ),
                );
              }
              continue;
            }
          }
        }

        if (clientsSnapshot != null) {
          final client = isClient(
            doc.id,
            clientsSnapshot!,
          );
          if (client != null) {
            Branch? branch = Branch.getBranch(
              client['id'],
              appRepository.branches,
            );
            if (branch != null) {
              if (appRepository.userRole.permissions.canViewClients &&
                  (appRepository.userRole is MasterAdmin ||
                      appRepository.userRole is Admin ||
                      (appRepository.userRole is CompanyManager &&
                          appRepository.userRole.company.id ==
                              branch.company.id) ||
                      (appRepository.userRole is BranchManager &&
                          appRepository.userRole.branch.id == branch.id))) {
                users.clients.add(
                  Client(
                    branch: branch,
                    permissions: client['permissions'],
                    info: UserInfo.fromMap(
                      userData,
                      doc.id,
                    ),
                  ),
                );
              }
              continue;
            }
          }
        }

        users.noRoleUsers.add(
          NoRoleUser(
            info: UserInfo.fromMap(
              userData,
              doc.id,
            ),
          ),
        );
      }
      return users;
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  bool isMasterAdmin(String userId, QuerySnapshot snapshot) {
    if (snapshot.docs.any((user) => user.id == userId)) {
      return true;
    } else {
      return false;
    }
  }

  AppPermissions? isAdmin(String userId, QuerySnapshot snapshot) {
    try {
      final userDoc = snapshot.docs.firstWhere((user) => user.id == userId);
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      if (userData != null) {
        return AppPermissions.fromAdminMap(userData['permissions']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic>? isCompanyManager(
      String userId, QuerySnapshot snapshot) {
    try {
      final userDoc = snapshot.docs.firstWhere((user) => user.id == userId);
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      if (userData != null) {
        return {
          'id': userData['company'],
          'permissions': AppPermissions.fromCompanyManagerMap(
            userData['permissions'],
          ),
        };
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic>? isBranchManager(String userId, QuerySnapshot snapshot) {
    try {
      final userDoc = snapshot.docs.firstWhere((user) => user.id == userId);
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      if (userData != null) {
        return {
          'id': userData['branch'],
          'permissions': AppPermissions.fromBranchManagerMap(
            userData['permissions'],
          ),
        };
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic>? isEmployee(String userId, QuerySnapshot snapshot) {
    try {
      final userDoc = snapshot.docs.firstWhere((user) => user.id == userId);
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      if (userData != null) {
        return {
          'id': userData['branch'],
          'permissions': AppPermissions.fromEmployeeMap(
            userData['permissions'],
          ),
        };
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic>? isClient(String userId, QuerySnapshot snapshot) {
    try {
      final userDoc = snapshot.docs.firstWhere((user) => user.id == userId);
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      if (userData != null) {
        return {
          'id': userData['branch'],
          'permissions': AppPermissions.fromClientMap(
            userData['permissions'],
          ),
        };
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
