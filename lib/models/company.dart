import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/branch.dart';

class Company {
  String? id;
  int? code;
  Timestamp? createdAt;
  String name;
  String address;
  String phoneNumber;
  String email;
  String logoURL;
  String comment;

  Company({
    this.id,
    this.code,
    this.createdAt,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.logoURL,
    required this.comment,
  });

  static Company? getCompany(String id, List<Company> companies) {
    try {
      return companies.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Branch> getBranches(String companyId, List<Branch> branches) {
    try {
      return branches
          .where((branch) => branch.company.id == companyId)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'logoURL': logoURL,
      'comment': comment,
    };
  }

  factory Company.fromMap(Map<String, dynamic> map, String documentId) {
    return Company(
      id: documentId,
      code: map['code'],
      name: map['name'],
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      logoURL: map['logoURL'],
      comment: map['comment'],
      createdAt: map['createdAt'],
    );
  }
}
