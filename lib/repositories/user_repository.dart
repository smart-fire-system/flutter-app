import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/premissions.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/repositories/branch_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class UsersAndBranches {
  List<MasterAdmin> masterAdmins = [];
  List<Admin> admins = [];
  List<CompanyManager> companyManagers = [];
  List<BranchManager> branchManagers = [];
  List<Employee> employees = [];
  List<Client> clients = [];
  List<NoRoleUser> noRoleUsers = [];
  List<Branch> branches = [];
  List<Company> companies = [];
}

class UserRepository {
  final AuthRepository authRepository;
  final BranchRepository branchRepository;
  final FirebaseFirestore _firestore;
  UserRepository({required this.authRepository})
      : _firestore = FirebaseFirestore.instance,
        branchRepository = BranchRepository();

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

  Future<void> changeAccessRole(
      String id, UserRole oldRole, UserRole newRole) async {
    try {
      await _firestore.runTransaction((transaction) async {
        try {
          DocumentReference userRef = _firestore.collection('users').doc(id);
          DocumentSnapshot userSnapshot = await transaction.get(userRef);
          if (!userSnapshot.exists) {
            throw Exception("User not found");
          }
          transaction.update(userRef, {'role': UserInfo.getRoleId(newRole)});
          if (oldRole != UserRole.admin) {
            DocumentReference oldRoleRef =
                _firestore.collection('${UserInfo.getRoleId(oldRole)}s').doc(id);
            transaction.delete(oldRoleRef);
          }
          if (newRole != UserRole.admin) {
            DocumentReference newRoleRef =
                _firestore.collection('${UserInfo.getRoleId(newRole)}s').doc(id);
            transaction.set(newRoleRef, <String, dynamic>{});
          }
        } catch (e) {
          if (e is FirebaseException) {
            throw Exception(e.code);
          } else {
            throw Exception(e.toString());
          }
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

  Future<void> deleteUser(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<UsersAndBranches> getUsersAndBranches() async {
    UsersAndBranches usersAndBranches = UsersAndBranches();
    try {
      final branchesData = await branchRepository.getAllBranchedAndCompanies();
      usersAndBranches.branches = branchesData['branches'] as List<Branch>;
      usersAndBranches.companies = branchesData['companies'] as List<Company>;

      final usersSnapshot =
          await _firestore.collection('users').orderBy('name').get();
      final masterAdminsSnapshot =
          await _firestore.collection('masterAdmins').get();
      final adminsSnapshot = await _firestore.collection('admins').get();
      final companyManagersSnapshot =
          await _firestore.collection('companyManagers').get();
      final branchManagersSnapshot =
          await _firestore.collection('branchManagers').get();
      final employeesSnapshot = await _firestore.collection('employees').get();
      final clientsSnapshot = await _firestore.collection('clients').get();

      for (var doc in usersSnapshot.docs) {
        Map<String, dynamic> userData = doc.data();

        if (isMasterAdmin(doc.id, masterAdminsSnapshot)) {
          usersAndBranches.masterAdmins.add(
            MasterAdmin(
              info: UserInfo.fromMap(
                userData,
                doc.id,
              ),
            ),
          );
          continue;
        }

        final premissions = isAdmin(doc.id, adminsSnapshot);
        if (premissions != null) {
          usersAndBranches.admins.add(
            Admin(
              premissions: premissions,
              info: UserInfo.fromMap(
                userData,
                doc.id,
              ),
            ),
          );
          continue;
        }

        final companyManager = isCompanyManager(
          doc.id,
          companyManagersSnapshot,
        );
        if (companyManager != null) {
          Company? company = Company.getCompany(
            companyManager['id'],
            usersAndBranches.companies,
          );
          if (company != null) {
            usersAndBranches.companyManagers.add(
              CompanyManager(
                company: company,
                branches:
                    Company.getBranches(company.id!, usersAndBranches.branches),
                premissions: companyManager['premissions'],
                info: UserInfo.fromMap(
                  userData,
                  doc.id,
                ),
              ),
            );
            continue;
          }
        }

        final branchManager = isBranchManager(
          doc.id,
          branchManagersSnapshot,
        );
        if (branchManager != null) {
          Branch? branch = Branch.getBranch(
            branchManager['id'],
            usersAndBranches.branches,
          );
          if (branch != null) {
            usersAndBranches.branchManagers.add(
              BranchManager(
                branch: branch,
                premissions: branchManager['premissions'],
                info: UserInfo.fromMap(
                  userData,
                  doc.id,
                ),
              ),
            );
            continue;
          }
        }

        final employee = isEmployee(
          doc.id,
          employeesSnapshot,
        );
        if (employee != null) {
          Branch? branch = Branch.getBranch(
            employee['id'],
            usersAndBranches.branches,
          );
          if (branch != null) {
            usersAndBranches.employees.add(
              Employee(
                branch: branch,
                premissions: employee['premissions'],
                info: UserInfo.fromMap(
                  userData,
                  doc.id,
                ),
              ),
            );
            continue;
          }
        }

        final client = isClient(
          doc.id,
          clientsSnapshot,
        );
        if (client != null) {
          Branch? branch = Branch.getBranch(
            client['id'],
            usersAndBranches.branches,
          );
          if (branch != null) {
            usersAndBranches.clients.add(
              Client(
                branch: branch,
                premissions: client['premissions'],
                info: UserInfo.fromMap(
                  userData,
                  doc.id,
                ),
              ),
            );
            continue;
          }
        }

        usersAndBranches.noRoleUsers.add(
          NoRoleUser(
            info: UserInfo.fromMap(
              userData,
              doc.id,
            ),
          ),
        );
      }
      return usersAndBranches;
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

  AppPremessions? isAdmin(String userId, QuerySnapshot snapshot) {
    try {
      final userDoc = snapshot.docs.firstWhere((user) => user.id == userId);
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      if (userData != null) {
        return AppPremessions.fromAdminMap(userData['premissions']);
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
          'premissions': AppPremessions.fromCompanyManagerMap(
            userData['premissions'],
          ),
        };
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic>? isBranchManager(
      String userId, QuerySnapshot snapshot) {
    try {
      final userDoc = snapshot.docs.firstWhere((user) => user.id == userId);
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      if (userData != null) {
        return {
          'id': userData['branch'],
          'premissions': AppPremessions.fromBranchManagerMap(
            userData['premissions'],
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
          'premissions': AppPremessions.fromEmployeeMap(
            userData['premissions'],
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
          'premissions': AppPremessions.fromClientMap(
            userData['premissions'],
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
