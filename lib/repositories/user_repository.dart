import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/admin.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class UserRepository {
  final AuthRepository authRepository;
  UserRepository({required this.authRepository});

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

  Future<void> changeAccessRole(String id, UserRole newRole) async {
    print("TODO: changeAccessRole");
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> deleteUser(String id) async {
    print("TODO: deleteUser");
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<List<Admin>> getAdminsList({bool includeCurrentUser = false}) async {
    print("TODO: Handle getAdminsList");
    await Future.delayed(const Duration(milliseconds: 500));
    List<Admin> admins = [
      Admin(
          index: 1,
          id: "ID1",
          name: "John Doe 1",
          email: "example1@example.com",
          countryCode: "+251",
          phoneNumber: "01005155"),
      Admin(
          index: 2,
          id: "ID2",
          name: "John Doe 2",
          email: "example2@example.com",
          countryCode: "+252",
          phoneNumber: "6516541102"),
      Admin(
          index: 3,
          id: "ID3",
          name: "John Doe 3",
          email: "example3@example.com",
          countryCode: "+253",
          phoneNumber: "6419641669"),
    ];
    return admins;
  }

  Future<List<User>> getNoRoleList() async {
    print("TODO: Handle getNoRoleList");
    await Future.delayed(const Duration(milliseconds: 500));
    List<User> users = [
      User(
          id: "ID1",
          name: "John Doe 1",
          email: "example1@example.com",
          countryCode: "+251",
          phoneNumber: "01005155",
          role: UserRole.noRole),
      User(
          id: "ID2",
          name: "John Doe 2",
          email: "example2@example.com",
          countryCode: "+252",
          phoneNumber: "6516541102",
          role: UserRole.noRole),
      User(
          id: "ID3",
          name: "John Doe 3",
          email: "example3@example.com",
          countryCode: "+253",
          phoneNumber: "6419641669",
          role: UserRole.noRole),
    ];
    return users;
  }
}
