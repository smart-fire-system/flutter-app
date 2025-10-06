import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/company.dart';

class ContractFirstParty {
  String name;
  String address;
  String commercialRecord;
  String g;
  String idNumber;
  String signatureUrl;
  ContractFirstParty({
    required this.name,
    required this.address,
    required this.commercialRecord,
    required this.g,
    required this.idNumber,
    required this.signatureUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'commercialRecord': commercialRecord,
      'g': g,
      'idNumber': idNumber,
      'signatureUrl': signatureUrl,
    };
  }

  factory ContractFirstParty.fromMap(Map<String, dynamic> map) {
    return ContractFirstParty(
      name: map['name'],
      address: map['address'],
      commercialRecord: map['commercialRecord'],
      g: map['g'],
      idNumber: map['idNumber'],
      signatureUrl: map['signatureUrl'],
    );
  }
}

class Branch {
  int? code;
  String? id;
  String name;
  String address;
  String phoneNumber;
  String email;
  String comment;
  Timestamp? createdAt;
  Company company;
  ContractFirstParty? contractFirstParty;

  Branch({
    this.id,
    this.code,
    this.createdAt,
    this.contractFirstParty,
    required this.company,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.comment,
  });

  static Branch? getBranch(String id, List<Branch> branches) {
    try {
      return branches.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'company': company.id,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'comment': comment,
    };
  }

  factory Branch.fromMap({
    required Map<String, dynamic> map,
    required String branchId,
    List<Company>? companies,
    Company? company,
  }) {
    Company branchCompany;
    assert(company != null || companies != null);
    if (company != null) {
      branchCompany = company;
    } else if (companies != null) {
      try {
        branchCompany =
            companies.firstWhere((element) => element.id == map['company']);
      } catch (_) {
        throw Exception('Company not found');
      }
    } else {
      throw Exception('Company not found');
    }
    return Branch(
      id: branchId,
      company: branchCompany,
      code: map['code'],
      name: map['name'],
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      comment: map['comment'],
      createdAt: map['createdAt'],
      contractFirstParty: map['contractFirstParty'] != null
          ? ContractFirstParty.fromMap(map['contractFirstParty'])
          : null,
    );
  }
}
