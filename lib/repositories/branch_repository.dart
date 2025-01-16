import 'dart:io';
import 'package:fire_alarm_system/utils/image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';

class BranchRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  BranchRepository()
      : _firestore = FirebaseFirestore.instance,
        _storage = FirebaseStorage.instance;

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

  Future<void> modifyCompany(Company company, File? logoFile) async {
    try {
      if (logoFile != null) {
        company.logoURL = await _updloadCompanyLogo(logoFile, company.id!);
      }
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

  Future<String> addBranch(Branch branch) async {
    try {
      final docSnapshot =
          await _firestore.collection('info').doc('maxBranchCode').get();
      await _firestore
          .collection('info')
          .doc('maxBranchCode')
          .update({'value': FieldValue.increment(1)});
      final branchRef = await _firestore.collection('branches').add({
        'code': docSnapshot.data()?['value'] + 1,
        'createdAt': FieldValue.serverTimestamp(),
        ...branch.toMap(),
      });
      return branchRef.id;
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<String> addCompany(Company company, File logoFile) async {
    try {
      final docSnapshot =
          await _firestore.collection('info').doc('maxCompanyCode').get();
      await _firestore
          .collection('info')
          .doc('maxCompanyCode')
          .update({'value': FieldValue.increment(1)});
      final branchRef = await _firestore.collection('companies').add({
        'code': docSnapshot.data()?['value'] + 1,
        'createdAt': FieldValue.serverTimestamp(),
        ...company.toMap(),
      });
      company.id = branchRef.id;
      company.logoURL = await _updloadCompanyLogo(logoFile, company.id!);
      await _firestore
          .collection('companies')
          .doc(company.id!)
          .update({'logoURL': company.logoURL});
      return company.id!;
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

  Future<String> _updloadCompanyLogo(File logoFile, String companyId) async {
    Uint8List resizedImageData =
        await AppImage.compressAndResizeImage(logoFile);
    final imageRef = _storage
        .refFromURL('gs://smart-fire-system-app.firebasestorage.app')
        .child('companies')
        .child('$companyId.jpg');
    await imageRef.putData(
      resizedImageData,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return await imageRef.getDownloadURL();
  }
}
