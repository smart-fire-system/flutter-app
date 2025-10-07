import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class ErrorLogger {
  static File? _file;
  static Future<void> _pending = Future.value();
  static bool _isUploading = false;

  ErrorLogger();

  static Future<void> init() async {
    if (_file != null) return;
    final dir = await getApplicationSupportDirectory();
    await Directory(dir.path).create(recursive: true);
    _file = File('${dir.path}/error_log.txt');
  }

  static Future<void> log(Object error, StackTrace stack,
      {String? where}) async {
    await init();
    final time = DateTime.now().toIso8601String();
    final entry = StringBuffer()
      ..writeln('-------------------------')
      ..writeln('🕒 $time')
      ..writeln('Function: ${where ?? "Unknown"}')
      ..writeln('Type: ${error.runtimeType}')
      ..writeln('Message: $error')
      ..writeln('Stack Trace:')
      ..writeln(stack.toString())
      ..writeln('-------------------------');
    _pending = _pending.then((_) async {
      final sink = _file!.openWrite(mode: FileMode.append);
      sink.write(entry.toString());
      await sink.flush();
      await sink.close();
    });
    await _pending;
  }

  static Future<String> readAll({bool waitForFlush = true}) async {
    await init();
    if (waitForFlush) await _pending;
    if (!await _file!.exists()) return 'No logs yet.';
    final raf = await _file!.open(mode: FileMode.read);
    try {
      final length = await raf.length();
      await raf.setPosition(0);
      final bytes = await raf.read(length);
      return utf8.decode(bytes, allowMalformed: true);
    } finally {
      await raf.close();
    }
  }

  static Future<void> uploadErrorLog() async {
    if (_isUploading) return;
    _isUploading = true;
    firebase.User? firebaseUser = firebase.FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;
    await init();
    if (!await _file!.exists()) return;
    final size = await _file!.length();
    if (size == 0) return;
    try {
      final errorLogRef = FirebaseStorage.instance
          .refFromURL('gs://smart-fire-system-app.firebasestorage.app')
          .child('errorLog')
          .child(firebaseUser.uid)
          .child(
              'error_log_${DateTime.now().toIso8601String().replaceAll(':', '-')}.txt');
      await errorLogRef.putFile(
        _file!,
        SettableMetadata(
          contentType: 'text/plain',
          customMetadata: {
            'source': 'flutter-app',
            'bytes': '$size',
            'createdAt': DateTime.now().toUtc().toIso8601String(),
          },
        ),
      );
      await _file!.delete();
      _isUploading = false;
    } catch (_) {
      return;
    }
  }
}
