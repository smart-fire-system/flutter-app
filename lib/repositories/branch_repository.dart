import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';

class BranchRepository {
  final FirebaseFirestore _firestore;
  BranchRepository() : _firestore = FirebaseFirestore.instance;

  Future<Map<String, List<dynamic>>> getBranchesList() async {
    try {
      List<Company> companies = [];
      List<Branch> branches = [];
      QuerySnapshot branchesSnapshot =
          await _firestore.collection('branches').orderBy('name').get();
      QuerySnapshot companiesSnapshot =
          await _firestore.collection('companies').orderBy('name').get();
      for (var doc in companiesSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        companies.add(Company.fromMap(data, doc.id));
      }
      for (var doc in branchesSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        branches.add(Branch.fromMap(data, doc.id, companies));
      }
      return {'branches': branches, 'companies': companies};
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<List<Company>> getCompaniesList() async {
    try {
      List<Company> companies = [];
      QuerySnapshot companiesSnapshot =
          await _firestore.collection('companies').orderBy('name').get();
      for (var doc in companiesSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        companies.add(Company.fromMap(data, doc.id));
      }
      return companies;
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<void> modifyBranch(Branch branch) async {
    try {
      await _firestore
          .collection('branches')
          .doc(branch.id)
          .update(branch.toMap());
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<void> modifyCompany(Company company) async {
    try {
      await _firestore
          .collection('companies')
          .doc(company.id)
          .update(company.toMap());
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<void> addBranch(Branch branch) async {
    try {
      branch.createdAt = FieldValue.serverTimestamp() as Timestamp;
      await _firestore.collection('branches').add(branch.toMap());
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<void> deleteBranch(String branchId) async {
    try {
      await _firestore.collection('branches').doc(branchId).delete();
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }
}
