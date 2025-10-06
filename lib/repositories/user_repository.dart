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
  Users users = Users();
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
      UserRole? oldRole = getUserRole(userId);
      if (oldRole != null && oldRole != permissions.role) {
        final oldDocRef = _firestore
            .collection('${UserInfo.getRoleId(oldRole)}s')
            .doc(userId);
        final docSnapshot = await oldDocRef.get();
        if (docSnapshot.exists) {
          await oldDocRef.delete();
        }
      }
      if (permissions.role == UserRole.masterAdmin) {
        await _firestore.collection('masterAdmins').doc(userId).set({});
      } else if (permissions.role == UserRole.admin) {
        await _firestore
            .collection('admins')
            .doc(userId)
            .set(AppPermissions().toAdminMap(permissions));
      } else if (permissions.role == UserRole.companyManager) {
        await _firestore.collection('companyManagers').doc(userId).set(
              AppPermissions().toCompanyManagerMap(permissions, companyId),
            );
      } else if (permissions.role == UserRole.branchManager) {
        await _firestore.collection('branchManagers').doc(userId).set(
              AppPermissions().toBranchManagerMap(permissions, branchId),
            );
      } else if (permissions.role == UserRole.employee) {
        await _firestore.collection('employees').doc(userId).set(
              AppPermissions().toEmployeeMap(permissions, branchId),
            );
      } else if (permissions.role == UserRole.client) {
        await _firestore.collection('clients').doc(userId).set(
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

  UserRole? getUserRole(String userId) {
    if (isMasterAdmin(userId)) {
      return UserRole.masterAdmin;
    }
    if (isAdmin(userId) != null) {
      return UserRole.admin;
    }
    if (isCompanyManager(userId) != null) {
      return UserRole.companyManager;
    }
    if (isBranchManager(userId) != null) {
      return UserRole.branchManager;
    }
    if (isEmployee(userId) != null) {
      return UserRole.employee;
    }
    if (isClient(userId) != null) {
      return UserRole.client;
    }
    return null;
  }

  Users getAllUsers() {
    users.masterAdmins.clear();
    users.admins.clear();
    users.companyManagers.clear();
    users.branchManagers.clear();
    users.employees.clear();
    users.clients.clear();
    users.noRoleUsers.clear();
    try {
      for (var doc in usersSnapshot!.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        users.allUsers.add(
          UserInfo.fromMap(
            userData,
            doc.id,
          ),
        );

        if (isMasterAdmin(doc.id)) {
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

        final permissions = isAdmin(doc.id);
        if (permissions != null) {
          if (appRepository.userRole is MasterAdmin ||
              appRepository.userRole is Admin) {
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

        final companyManager = isCompanyManager(doc.id);
        if (companyManager != null) {
          Company? company = Company.getCompany(
            companyManager['id'],
            appRepository.companies,
          );
          if (company != null) {
            bool canView = false;
            dynamic user = appRepository.userRole;
            switch (user) {
              case MasterAdmin():
              case Admin():
                canView = true;
                break;
              case CompanyManager():
                canView = user.info.id == doc.id;
                break;
              case BranchManager():
                canView = user.branch.company.id == company.id;
                break;
              case Employee():
                canView = user.branch.company.id == company.id;
                break;
              case Client():
                canView = user.branch.company.id == company.id;
                break;
              default:
                canView = false;
                break;
            }
            if (canView) {
              users.companyManagers.add(
                CompanyManager(
                  company: company,
                  branches:
                      Company.getBranches(company.id!, appRepository.branches),
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

        final branchManager = isBranchManager(doc.id);
        if (branchManager != null) {
          Branch? branch = Branch.getBranch(
            branchManager['id'],
            appRepository.branches,
          );
          if (branch != null) {
            bool canView = false;
            dynamic user = appRepository.userRole;
            switch (user) {
              case MasterAdmin():
              case Admin():
                canView = true;
                break;
              case CompanyManager():
                canView = user.company.id == branch.company.id;
                break;
              case BranchManager():
                canView = user.info.id == doc.id;
                break;
              case Employee():
                canView = user.branch.id == branch.id;
                break;
              case Client():
                canView = user.branch.id == branch.id;
                break;
              default:
                canView = false;
                break;
            }
            if (canView) {
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

        final employee = isEmployee(doc.id);
        if (employee != null) {
          Branch? branch = Branch.getBranch(
            employee['id'],
            appRepository.branches,
          );
          if (branch != null) {
            bool canView = false;
            dynamic user = appRepository.userRole;
            switch (user) {
              case MasterAdmin():
              case Admin():
                canView = true;
                break;
              case CompanyManager():
                canView = user.company.id == branch.company.id;
                break;
              case BranchManager():
                canView = user.branch.id == branch.id;
                break;
              case Employee():
                canView = user.info.id == doc.id;
                break;
              case Client():
                canView = user.branch.id == branch.id;
                break;
              default:
                canView = false;
                break;
            }
            if (canView) {
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

        final client = isClient(doc.id);
        if (client != null) {
          Branch? branch = Branch.getBranch(
            client['id'],
            appRepository.branches,
          );
          if (branch != null) {
            bool canView = false;
            dynamic user = appRepository.userRole;
            switch (user) {
              case MasterAdmin():
              case Admin():
                canView = true;
                break;
              case CompanyManager():
                canView = user.company.id == branch.company.id;
                break;
              case BranchManager():
                canView = user.branch.id == branch.id;
                break;
              case Employee():
                canView = user.branch.id == branch.id;
                break;
              case Client():
                canView = user.branch.id == branch.id;
                break;
              default:
                canView = false;
                break;
            }
            if (canView) {
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

  bool isMasterAdmin(String userId) {
    if (masterAdminsSnapshot == null) {
      return false;
    }
    if (masterAdminsSnapshot!.docs.any((user) => user.id == userId)) {
      return true;
    } else {
      return false;
    }
  }

  AppPermissions? isAdmin(String userId) {
    if (adminsSnapshot == null) {
      return null;
    }
    try {
      final userDoc =
          adminsSnapshot!.docs.firstWhere((user) => user.id == userId);
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

  Map<String, dynamic>? isCompanyManager(String userId) {
    if (companyManagersSnapshot == null) {
      return null;
    }
    try {
      final userDoc =
          companyManagersSnapshot!.docs.firstWhere((user) => user.id == userId);
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

  Map<String, dynamic>? isBranchManager(String userId) {
    if (branchManagersSnapshot == null) {
      return null;
    }
    try {
      final userDoc =
          branchManagersSnapshot!.docs.firstWhere((user) => user.id == userId);
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

  Map<String, dynamic>? isEmployee(String userId) {
    if (employeesSnapshot == null) {
      return null;
    }
    try {
      final userDoc =
          employeesSnapshot!.docs.firstWhere((user) => user.id == userId);
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

  Map<String, dynamic>? isClient(String userId) {
    if (clientsSnapshot == null) {
      return null;
    }
    try {
      final userDoc =
          clientsSnapshot!.docs.firstWhere((user) => user.id == userId);
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
