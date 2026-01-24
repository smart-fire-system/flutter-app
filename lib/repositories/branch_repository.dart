import 'dart:io';
import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/repositories/app_repository.dart';
import 'package:fire_alarm_system/utils/image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/branch.dart';
import 'package:fire_alarm_system/models/company.dart';

class BranchesAndCompanies {
  List<Branch> branches;
  List<Company> companies;
  BranchesAndCompanies({required this.branches, required this.companies});
}

class BranchRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final AppRepository appRepository;
  QuerySnapshot? branchesSnapshot;
  QuerySnapshot? companiesSnapshot;
  List<Branch> branches = [];
  List<Company> companies = [];
  BranchRepository({required this.appRepository})
      : _firestore = FirebaseFirestore.instance,
        _storage = FirebaseStorage.instance;

  void updateBranchesAndCompanies() {
    companies = [];
    branches = [];
    try {
      if (companiesSnapshot == null || branchesSnapshot == null) {
        return;
      }
      for (var doc in companiesSnapshot!.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Company company = Company.fromMap(data, doc.id);
        bool canView = false;
        dynamic user = appRepository.userRole;
        switch (user) {
          case MasterAdmin():
          case Admin():
            canView = true;
            break;
          case CompanyManager():
            canView = user.company.id == company.id;
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
          companies.add(company);
        }
      }
      for (var doc in branchesSnapshot!.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Branch branch;
        try {
          branch = Branch.fromMap(
            map: data,
            branchId: doc.id,
            companies: companies,
          );
        } catch (e) {
          continue;
        }
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
          branches.add(branch);
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>?> getCompanyAndBranches(String companyId) async {
    try {
      Company company;
      List<Branch> companyBranches = [];
      DocumentSnapshot companySnapshot =
          await _firestore.collection('companies').doc(companyId).get();
      if (!companySnapshot.exists) {
        return null;
      }
      company = Company.fromMap(
        companySnapshot.data() as Map<String, dynamic>,
        companySnapshot.id,
      );
      QuerySnapshot companyBranchesSnapshot = await _firestore
          .collection('branches')
          .orderBy('name')
          .where('company', isEqualTo: companyId)
          .get();
      for (var doc in companyBranchesSnapshot.docs) {
        Branch branch;
        try {
          branch = Branch.fromMap(
            map: doc.data() as Map<String, dynamic>,
            branchId: doc.id,
            company: company,
          );
        } catch (e) {
          continue;
        }
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
          companyBranches.add(branch);
        }
      }
      return {'branches': companyBranches, 'company': company};
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<Branch?> getBranch(String branchId) async {
    try {
      DocumentSnapshot branchDocument =
          await _firestore.collection('branches').doc(branchId).get();
      if (!branchDocument.exists) {
        return null;
      }
      Map<String, dynamic> branchData =
          branchDocument.data() as Map<String, dynamic>;
      DocumentSnapshot companyDocument = await _firestore
          .collection('companies')
          .doc(branchData['company'])
          .get();
      if (!companyDocument.exists) {
        return null;
      }
      Map<String, dynamic> companyData =
          companyDocument.data() as Map<String, dynamic>;
      return Branch.fromMap(
        map: branchData,
        branchId: branchDocument.id,
        company: Company.fromMap(
          companyData,
          companyDocument.id,
        ),
      );
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception(e.code);
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<void> modifyBranch(Branch branch, File? signatureFile) async {
    try {
      if (signatureFile != null) {
        branch.contractFirstParty.signatureUrl =
            await uploadBranchSignatureImage(branch.id!, signatureFile);
      }
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

  Future<String> uploadBranchSignatureImage(
      String branchId, File pickedFile) async {
    try {
      Uint8List resizedImageData =
          await AppImage.compressAndResizeImage(pickedFile);
      final imageRef = _storage
          .refFromURL('gs://smart-fire-system-app.firebasestorage.app')
          .child('branches')
          .child('signatures')
          .child('$branchId.jpg');
      await imageRef.putData(
        resizedImageData,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      return await imageRef.getDownloadURL();
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

  Future<String> addBranch(Branch branch, File? signatureFile) async {
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
      if (signatureFile != null) {
        branch.contractFirstParty.signatureUrl =
            await uploadBranchSignatureImage(branchRef.id, signatureFile);
      }
      await _firestore.collection('branches').doc(branchRef.id).update({
        'contractFirstParty.signatureUrl':
            branch.contractFirstParty.signatureUrl
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

  Future<void> deleteCompany(String companyId, List<Branch> branches) async {
    try {
      final batch = _firestore.batch();
      for (Branch branch in branches) {
        if (branch.company.id! == companyId) {
          final branchRef = _firestore.collection('branches').doc(branch.id!);
          batch.delete(branchRef);
        }
      }
      final companyRef = _firestore.collection('companies').doc(companyId);
      batch.delete(companyRef);
      await batch.commit();
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
