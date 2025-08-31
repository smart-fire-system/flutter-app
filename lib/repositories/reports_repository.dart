import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_alarm_system/models/report.dart';

class ReportsRepository {
  final FirebaseFirestore _firestore;

  ReportsRepository() : _firestore = FirebaseFirestore.instance;

  Future<List<ContractComponentItem>> readContractComponents() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('reportsMetaData')
          .doc('contractComponents')
          .get();

      if (!snapshot.exists) return [];

      final Map<String, dynamic>? data = snapshot.data();
      if (data == null) return [];

      final List<dynamic> rawItems = List.from(data['items'] ?? []);
      return rawItems
          .whereType<Map>()
          .map((e) => ContractComponentItem(
                arName: (e['arName'] ?? '').toString(),
                enName: (e['enName'] ?? '').toString(),
                description: (e['description'] ?? '').toString(),
                categoryIndex:
                    int.tryParse((e['categoryIndex'] ?? '0').toString()) ?? 0,
              ))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ContractComponentCategory>>
      readContractComponentsCategories() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('reportsMetaData')
          .doc('contractComponentCategories')
          .get();

      if (!snapshot.exists) return [];

      final Map<String, dynamic>? data = snapshot.data();
      if (data == null) return [];

      final List<dynamic> rawItems = List.from(data['categories'] ?? []);
      final List<ContractComponentCategory> categories = [
        ContractComponentCategory(
          arName: 'أخرى',
          enName: 'Other',
        )
      ];
      categories.addAll(rawItems
          .whereType<Map>()
          .map((e) => ContractComponentCategory(
                arName: (e['arName'] ?? '').toString(),
                enName: (e['enName'] ?? '').toString(),
              ))
          .toList());
      return categories;
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> setContractComponents(
      List<ContractComponentItem> components) async {
    try {
      // Ensure items have required keys as strings
      final List<Map<String, String>> sanitized = components
          .map((e) => {
                'arName': e.arName,
                'enName': e.enName,
                'description': e.description,
                'categoryIndex': e.categoryIndex.toString(),
              })
          .toList();

      await _firestore
          .collection('reportsMetaData')
          .doc('contractComponents')
          .set({'items': sanitized});
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
