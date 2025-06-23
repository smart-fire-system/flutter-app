import 'dart:async';
import 'package:fire_alarm_system/models/pin.dart';
import 'package:firebase_database/firebase_database.dart';

class MasterConfig {
  final Map<String, List<PinConfig>> pinsConfig;
  final List<bool> isClientAlive;

  MasterConfig({
    required this.pinsConfig,
    required this.isClientAlive,
  });
}

class SystemRepository {
  final FirebaseDatabase _db;

  SystemRepository() : _db = FirebaseDatabase.instance;

  Future<List<Master>> getMasters(int branchCode) async {
    final statusRef = _db.ref("branches/branch_$branchCode/status");
    final dataRef = _db.ref("branches/branch_$branchCode/data");
    final statusSnapshot = await statusRef.get();
    final dataSnapshot = await dataRef.get();
    return getMastersFromSnapshot(dataSnapshot, statusSnapshot);
  }

  Future<List<DateTime>> getLastSeen(int branchCode) async {
    final statusRef = _db.ref("branches/branch_$branchCode/status");
    final statusSnapshot = await statusRef.get();
    List<DateTime> lastSeen = [];
    if (statusSnapshot.exists) {
      final statusMap = statusSnapshot.value as Map<dynamic, dynamic>;
      for (var entry in statusMap.entries) {
        final status = statusMap[entry.key];
        final lastSeenEpoch = status['lastSeen'] ?? 0;
        lastSeen.add(DateTime.fromMillisecondsSinceEpoch(lastSeenEpoch * 1000));
      }
    }
    return lastSeen;
  }

  Future<void> triggerPin({
    required int masterId,
    required int clientId,
    required int pinIndex,
    required int request,
  }) async {
    final db = FirebaseDatabase.instance;

    final path =
        "masters/master_$masterId/commands/clients/$clientId/$pinIndex";
    final update = {
      "request": request,
      "requestTimestamp": ServerValue.timestamp, // UNIX time
    };

    try {
      await db.ref(path).update(update);
    } catch (e) {
      /* TODO */
    }
  }

  Future<void> sendCommand({
    required int branchCode,
    required int masterId,
    required int clientId,
    required int pinIndex,
    required int request,
    PinConfig? pinConfig,
  }) async {
    final db = FirebaseDatabase.instance;
    final path = "branches/branch_$branchCode/commands/master_$masterId";
    final update = {
      "clientId": clientId,
      "pinIndex": pinIndex,
      "request": request,
      "pinNumber": pinConfig?.number ?? 0,
      "pinMode": pinConfig?.mode ?? 0,
      "pinDirection": pinConfig?.direction ?? 0,
      "pinIsActive": pinConfig?.isActive ?? 0,
      "empty": 0,
    };

    try {
      await db.ref(path).update(update);
    } catch (e) {
      /* TODO */
    }
  }

  late StreamSubscription<DatabaseEvent>? _dataSubscription;
  void cancelStream() {
    _dataSubscription?.cancel();
  }

  void startStream(int branchCode, Function(List<Master>) onChange) {
    final path = "branches/branch_$branchCode/data";
    final ref = FirebaseDatabase.instance.ref(path);
    //_dataSubscription?.cancel();
    _dataSubscription = ref.onValue.listen((event) async {
      if (event.snapshot.exists) {
        final statusRef =
            FirebaseDatabase.instance.ref("branches/branch_$branchCode/status");
        final statusSnapshot = await statusRef.get();
        final dataSnapshot = event.snapshot;
        List<Master> masters =
            getMastersFromSnapshot(dataSnapshot, statusSnapshot);
        onChange(masters);
      } else {
        /* TODO */
      }
    });
  }

  List<Master> getMastersFromSnapshot(
      DataSnapshot dataSnapshot, DataSnapshot statusSnapshot) {
    List<Master> masters = [];
    if (dataSnapshot.exists && statusSnapshot.exists) {
      final statusMap = statusSnapshot.value as Map<dynamic, dynamic>;
      final dataMap = dataSnapshot.value as Map<dynamic, dynamic>;
      for (var entry in dataMap.entries) {
        final masterIdStr = entry.key;
        if (!statusMap.containsKey(masterIdStr)) continue;
        final status = statusMap[masterIdStr];
        if (status == null) continue;
        final isOnline = status['isOnline'] ?? false;
        final lastSeenEpoch = status['lastSeen'] ?? 0;
        final clientsConfigRaw = List.from(entry.value['clientsConfig'] ?? []);
        final isClientAliveRaw =
            List<bool>.from(entry.value['isClientAlive'] ?? []);
        List<List<PinConfig>> parsedPinsConfig = [];
        for (var clientPinsRaw in clientsConfigRaw) {
          if (clientPinsRaw == null) {
            parsedPinsConfig.add([]);
            continue;
          }
          List<PinConfig> pins = [];
          for (var entry in List.from(clientPinsRaw).asMap().entries) {
            final index = entry.key;
            final pinMap = Map<String, dynamic>.from(entry.value);
            pins.add(PinConfig.fromMap(pinMap, index));
          }
          parsedPinsConfig.add(pins);
        }
        final masterId = int.tryParse(masterIdStr.split("_").last) ?? -1;
        masters.add(Master(
          id: masterId,
          isActive: isOnline,
          lastSeen: DateTime.fromMillisecondsSinceEpoch(lastSeenEpoch * 1000),
          pinsConfig: parsedPinsConfig,
          isClientAlive: isClientAliveRaw,
        ));
      }
    }
    return masters;
  }
}
