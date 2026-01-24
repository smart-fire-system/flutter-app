import 'dart:io';

import 'package:fire_alarm_system/utils/app_version.dart';

class AppVersion {
  final int major;
  final int minor;
  final int patch;
  final int buildNumber;

  AppVersion({
    this.major = 0,
    this.minor = 0,
    this.patch = 0,
    this.buildNumber = 0,
  });

  static AppVersion get currentAndroid => AppVersion(
        major: androidVersionMajor,
        minor: androidVersionMinor,
        patch: androidVersionPatch,
        buildNumber: androidBuildNumber,
      );

  static AppVersion get currentIos => AppVersion(
        major: iosVersionMajor,
        minor: iosVersionMinor,
        patch: iosVersionPatch,
        buildNumber: iosBuildNumber,
      );

  bool isGreaterThan(AppVersion other) {
    if (major != other.major) {
      return major > other.major;
    }
    if (minor != other.minor) {
      return minor > other.minor;
    }
    if (patch != other.patch) {
      return patch > other.patch;
    }
    return buildNumber > other.buildNumber;
  }
}

class AppVersionInfo {
  final String updateMessageAr;
  final String updateMessageEn;
  final bool isAppAvailable;
  AppVersionInfo({
    required this.updateMessageAr,
    required this.updateMessageEn,
    required this.isAppAvailable,
  });
}

class AppVersionData {
  final AppVersionInfo androidInfo;
  final AppVersionInfo iosInfo;
  final AppVersion currentAndroid = AppVersion.currentAndroid;
  final AppVersion latestAndroid;
  final AppVersion minimumAndroid;
  final AppVersion currentIos = AppVersion.currentIos;
  final AppVersion latestIos;
  final AppVersion minimumIos;
  AppVersionData({
    required this.androidInfo,
    required this.iosInfo,
    required this.latestAndroid,
    required this.minimumAndroid,
    required this.latestIos,
    required this.minimumIos,
  });
  String get currentAndroidString =>
      '${currentAndroid.major}.${currentAndroid.minor}.${currentAndroid.patch}';
  String get currentIosString =>
      '${currentIos.major}.${currentIos.minor}.${currentIos.patch}';
  String get latestAndroidString =>
      '${latestAndroid.major}.${latestAndroid.minor}.${latestAndroid.patch}';
  String get latestIosString =>
      '${latestIos.major}.${latestIos.minor}.${latestIos.patch}';
  String get minimumAndroidString =>
      '${minimumAndroid.major}.${minimumAndroid.minor}.${minimumAndroid.patch}';
  String get minimumIosString =>
      '${minimumIos.major}.${minimumIos.minor}.${minimumIos.patch}';
  bool get isAndroidUpdateAvailable =>
      latestAndroid.isGreaterThan(currentAndroid);
  bool get isAndroidUpdateRequired =>
      minimumAndroid.isGreaterThan(currentAndroid);
  bool get isIosUpdateAvailable => latestIos.isGreaterThan(currentIos);
  bool get isIosUpdateRequired => minimumIos.isGreaterThan(currentIos);
  bool get isUpdateRequired =>
      (Platform.isAndroid &&
          (isAndroidUpdateRequired || !androidInfo.isAppAvailable)) ||
      (Platform.isIOS && (isIosUpdateRequired || !iosInfo.isAppAvailable));
  bool get isUpdateAvailable =>
      (isAndroidUpdateAvailable && Platform.isAndroid) ||
      (isIosUpdateAvailable && Platform.isIOS);

  factory AppVersionData.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> androidData = map['android'] ?? {};
    Map<String, dynamic> iosData = map['ios'] ?? {};
    return AppVersionData(
      androidInfo: AppVersionInfo(
        updateMessageAr: androidData['info']?['updateMessageAr'] ?? '',
        updateMessageEn: androidData['info']?['updateMessageEn'] ?? '',
        isAppAvailable: androidData['info']?['isAppAvailable'] ?? false,
      ),
      iosInfo: AppVersionInfo(
        updateMessageAr: iosData['info']?['updateMessageAr'] ?? '',
        updateMessageEn: iosData['info']?['updateMessageEn'] ?? '',
        isAppAvailable: iosData['info']?['isAppAvailable'] ?? false,
      ),
      latestAndroid: AppVersion(
        major: androidData['latest']?['major'] ?? 0,
        minor: androidData['latest']?['minor'] ?? 0,
        patch: androidData['latest']?['patch'] ?? 0,
        buildNumber: androidData['latest']?['buildNumber'] ?? 0,
      ),
      minimumAndroid: AppVersion(
        major: androidData['minimum']?['major'] ?? 0,
        minor: androidData['minimum']?['minor'] ?? 0,
        patch: androidData['minimum']?['patch'] ?? 0,
        buildNumber: androidData['minimum']?['buildNumber'] ?? 0,
      ),
      latestIos: AppVersion(
        major: iosData['latest']?['major'] ?? 0,
        minor: iosData['latest']?['minor'] ?? 0,
        patch: iosData['latest']?['patch'] ?? 0,
        buildNumber: iosData['latest']?['buildNumber'] ?? 0,
      ),
      minimumIos: AppVersion(
        major: iosData['minimum']?['major'] ?? 0,
        minor: iosData['minimum']?['minor'] ?? 0,
        patch: iosData['minimum']?['patch'] ?? 0,
        buildNumber: iosData['minimum']?['buildNumber'] ?? 0,
      ),
    );
  }
}
