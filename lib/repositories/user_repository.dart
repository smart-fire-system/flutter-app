import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/admin.dart';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/auth_repository.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class UserRepository {
  final AuthRepository authRepository;
  final FirebaseFirestore _firestore;
  UserRepository({required this.authRepository})
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

  Future<List<Admin>> getAdminsList({bool includeCurrentUser = false}) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .orderBy('name')
          .get();
      List<Admin> admins = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DocumentSnapshot adminDocSnapshot =
            await _firestore.collection('admins').doc(doc.id).get();
        if (adminDocSnapshot.exists) {
          Admin admin = Admin(
            id: doc.id,
            name: data['name'] ?? '',
            email: data['email'] ?? '',
            phoneNumber: data['phoneNumber'] ?? '',
            countryCode: data['countryCode'] ?? '',
          );
          admins.add(admin);
        }
      }
      return admins;
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<List<User>> getNoRoleList() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'none')
          .orderBy('name')
          .get();
      List<User> users = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        User user = User(
          id: doc.id,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          phoneNumber: data['phoneNumber'] ?? '',
          countryCode: data['countryCode'] ?? '',
          role: UserRole.noRole,
        );
        return user;
      }).toList();
      return users;
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }
}
