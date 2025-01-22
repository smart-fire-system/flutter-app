import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:cloud_functions/cloud_functions.dart';
//import 'package:firebase_auth/firebase_auth.dart' as firebase;

class TestRespository {
  //final firebase.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  TestRespository()
      : //_firebaseAuth = firebase.FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance;

  Future<void> addCanFlags() async {
    final collectionRef = _firestore.collection('users');
    final snapshot = await collectionRef.get();
    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {
        'canViewBranches': true,
        'canEditBranches': true,
        'canAddBranches': true,
        'canDeleteBranches': true,
        'canViewCompanies': true,
        'canEditCompanies': true,
        'canAddCompanies': true,
        'canDeleteCompanies': true,
        'canviewAdmins': true,
        'canEditAdmins': true,
        'canAddAdmins': true,
        'canDeleteAdmins': true,
        'canviewCompanyManagers': true,
        'canEditCompanyManagers': true,
        'canAddCompanyManagers': true,
        'canDeleteCompanyManagers': true,
        'canviewBranchManagers': true,
        'canEditBranchManagers': true,
        'canAddBranchManagers': true,
        'canDeleteBranchManagers': true,
        'canviewEmployees': true,
        'canEditEmployees': true,
        'canAddEmployees': true,
        'canDeleteEmployees': true,
        'canviewClients': true,
        'canEditClients': true,
        'canAddClients': true,
        'canDeleteClients': true,
      });
    }
    await batch.commit();
  }

  Future<void> addMasterAdmin() async {
    /*
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('addMasterAdmin');
      final response = await callable.call({
        'uid': _firebaseAuth.currentUser!.uid,
      });
      print("------------------------------------------");
      print(response.data['message']);
      print("------------------------------------------");
      await _firebaseAuth.currentUser!.getIdToken(true);

      final user = _firebaseAuth.currentUser!;
      final idTokenResult = await user.getIdTokenResult();
      final claims = idTokenResult.claims;
      bool? role = claims?['isMasterAdmin'];
      print("------------------------------------------");
      print('User role: ${role ?? "No role assigned"}');
      print(claims);
      print("------------------------------------------");
    } catch (error) {
      print("------------------------------------------");
      print('Error setting user as company manager: $error');
      print("------------------------------------------");
    }*/
  }

  Future<void> addCompanyManager() async {
    /*
    print("------------------------------------------");
    print('Start');
    print("------------------------------------------");

    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('addCompanyManager');
      final response = await callable.call({
        'uid': _firebaseAuth.currentUser!.uid,
        'companyId': "ddd",
        'canAddBranchManagers': false,
        'canEditBranchManagers': false,
        'canDeleteBranchManagers': false,
        'canAddEmployees': false,
        'canEditEmployees': false,
        'canDeleteEmployees': false,
        'canEditCompanies': false,
        'canAddBranches': false,
        'canEditBranches': false,
        'canDeleteBranches': false,
      });
      print("------------------------------------------");
      print(response.data['message']);
      print("------------------------------------------");
      await _firebaseAuth.currentUser!.getIdToken(true);

      final user = _firebaseAuth.currentUser!;
      final idTokenResult = await user.getIdTokenResult();
      final claims = idTokenResult.claims;
      String? role = claims?['role'];
      print("------------------------------------------");
      print('User role: ${role ?? "No role assigned"}');
      print(claims);
      print("------------------------------------------");
    } catch (error) {
      print("------------------------------------------");
      print('Error setting user as company manager: $error');
      print("------------------------------------------");
    }*/
  }
}
