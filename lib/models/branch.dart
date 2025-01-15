import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/company.dart';

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

  Branch({
    this.id,
    this.code,
    this.createdAt,
    required this.company,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.comment,
  });

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

  factory Branch.fromMap(
      Map<String, dynamic> map, String documentId, List<Company> companies) {
    return Branch(
      id: documentId,
      company: companies.firstWhere((element) => element.id == map['company']),
      code: map['code'],
      name: map['name'],
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      comment: map['comment'],
      createdAt: map['createdAt'],
    );
  }
}
