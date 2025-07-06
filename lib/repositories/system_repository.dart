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
  List<Master> _masters;

  SystemRepository()
      : _db = FirebaseDatabase.instance,
        _masters = [];

  List<Master> get masters => _masters;

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
      await _db.ref(path).update(update);
    } catch (e) {
      /* TODO */
    }
  }

  StreamSubscription<DatabaseEvent>? _dataSubscription;
  void cancelStream() {
    if (_dataSubscription != null) {
      _dataSubscription?.cancel();
    }
  }

  void startStream(int branchCode, Function(void) onChange) {
    final ref = _db.ref('branches/branch_$branchCode');
    _dataSubscription = ref.onValue.listen((event) async {
      if (event.snapshot.exists) {
        _masters = getMastersFromSnapshot(event.snapshot, branchCode);
      } else {
        _masters = [];
      }
      onChange(null);
    });
  }

  List<Master> getMastersFromSnapshot(DataSnapshot snapshot, int branchCode) {
    List<Master> masters = [];
    if (snapshot.exists) {
      final branchData = snapshot.value as Map<dynamic, dynamic>;
      final statusMap = branchData['status'] as Map<dynamic, dynamic>;
      final dataMap = branchData['data'] as Map<dynamic, dynamic>;
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
        final isClientConfiguredRaw =
            List<bool>.from(entry.value['isClientConfigured'] ?? []);
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
          branchCode: branchCode,
          id: masterId,
          isActive: isOnline,
          lastSeen: DateTime.fromMillisecondsSinceEpoch(lastSeenEpoch * 1000),
          pinsConfig: parsedPinsConfig,
          isClientAlive: isClientAliveRaw,
          isClientConfigured: isClientConfiguredRaw,
        ));
      }
    }
    return masters;
  }
}
