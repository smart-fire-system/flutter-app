import 'package:cloud_firestore/cloud_firestore.dart';

class TestRespository {
  final FirebaseFirestore _firestore;
  TestRespository() : _firestore = FirebaseFirestore.instance;

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
}
