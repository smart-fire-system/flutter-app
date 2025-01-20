import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/repositories/branch_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class UsersAndBranches {
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
          transaction.update(userRef, {'role': User.getRoleId(newRole)});
          if (oldRole != UserRole.noRole) {
            DocumentReference oldRoleRef =
                _firestore.collection('${User.getRoleId(oldRole)}s').doc(id);
            transaction.delete(oldRoleRef);
          }
          if (newRole != UserRole.noRole) {
            DocumentReference newRoleRef =
                _firestore.collection('${User.getRoleId(newRole)}s').doc(id);
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
      final branchesData = await branchRepository.getBranchesList();
      usersAndBranches.branches = branchesData['branches'] as List<Branch>;
      usersAndBranches.companies = branchesData['companies'] as List<Company>;
      final usersSnapshot =
          await _firestore.collection('users').orderBy('name').get();
      final adminsSnapshot = await _firestore.collection('admins').get();
      final companyManagersSnapshot =
          await _firestore.collection('companyManagers').get();
      final branchManagersSnapshot =
          await _firestore.collection('branchManagers').get();
      final employeesSnapshot = await _firestore.collection('employees').get();
      final clientsSnapshot = await _firestore.collection('clients').get();
      for (var doc in usersSnapshot.docs) {
        Map<String, dynamic> userData = doc.data();
        bool noRole = true;
        if (userData['role'] == 'admin' &&
            adminsSnapshot.docs.any((doc) => doc.id == doc.id)) {
          noRole = false;
          usersAndBranches.admins.add(
            Admin(
              info: User.fromMap(
                userData,
                doc.id,
              ),
            ),
          );
        } else if (userData['role'] == 'companyManager' &&
            companyManagersSnapshot.docs.any((doc) => doc.id == doc.id)) {
          final managerDoc = companyManagersSnapshot.docs
              .firstWhere((doc) => doc.id == doc.id);
          Company? company = Company.getCompany(
              managerDoc.data()['company'], usersAndBranches.companies);
          if (company != null) {
            noRole = false;
            usersAndBranches.companyManagers.add(
              CompanyManager(
                company: company,
                branches:
                    Company.getBranches(company.id!, usersAndBranches.branches),
                info: User.fromMap(
                  userData,
                  doc.id,
                ),
              ),
            );
          }
        } else if (userData['role'] == 'branchManager' &&
            branchManagersSnapshot.docs.any((doc) => doc.id == doc.id)) {
          final managerDoc =
              branchManagersSnapshot.docs.firstWhere((doc) => doc.id == doc.id);
          Branch? branch = Branch.getBranch(
              managerDoc.data()['branch'], usersAndBranches.branches);
          if (branch != null) {
            noRole = false;
            usersAndBranches.branchManagers.add(
              BranchManager(
                branch: branch,
                info: User.fromMap(
                  userData,
                  doc.id,
                ),
              ),
            );
          }
        } else if (userData['role'] == 'employee' &&
            employeesSnapshot.docs.any((doc) => doc.id == doc.id)) {
          final employeeDoc =
              employeesSnapshot.docs.firstWhere((doc) => doc.id == doc.id);
          Branch? branch = Branch.getBranch(
              employeeDoc.data()['branch'], usersAndBranches.branches);
          if (branch != null) {
            noRole = false;
            usersAndBranches.employees.add(
              Employee(
                branch: branch,
                info: User.fromMap(
                  userData,
                  doc.id,
                ),
              ),
            );
          }
        } else if (userData['role'] == 'client' &&
            clientsSnapshot.docs.any((doc) => doc.id == doc.id)) {
          final clientDoc =
              clientsSnapshot.docs.firstWhere((doc) => doc.id == doc.id);
          Branch? branch = Branch.getBranch(
              clientDoc.data()['branch'], usersAndBranches.branches);
          if (branch != null) {
            noRole = false;
            usersAndBranches.clients.add(
              Client(
                branch: branch,
                info: User.fromMap(
                  userData,
                  doc.id,
                ),
              ),
            );
          }
        }
        if (noRole) {
          userData['role'] = User.getRoleId(UserRole.noRole);
          usersAndBranches.noRoleUsers.add(
            NoRoleUser(
              info: User.fromMap(
                userData,
                doc.id,
              ),
            ),
          );
        }
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
}
