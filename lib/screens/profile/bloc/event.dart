import 'dart:io';

abstract class ProfileEvent {}

class Refresh extends ProfileEvent {
  final String? error;
  Refresh({this.error});
}

class ResetPasswordRequested extends ProfileEvent {}

class LogoutRequested extends ProfileEvent {}

class RefreshRequested extends ProfileEvent {}

class ChangeInfoRequested extends ProfileEvent {
  final String name;
  final String countryCode;
  final String phoneNumber;
  final File? signatureFile;
  ChangeInfoRequested({
    required this.name,
    required this.countryCode,
    required this.phoneNumber,
    this.signatureFile,
  });
}
