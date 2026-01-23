import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';

void openStore() {
  StoreLauncher.openStore(
    androidPackageName: 'com.hassan.firealarm',
    iosAppId: '1234567890',
  );
}

class StoreLauncher {
  static Future<bool> openStore({
    required String androidPackageName,
    required String iosAppId,
    bool preferInAppBrowser = false,
  }) async {
    try {
      if (Platform.isAndroid) {
        // 1) Play Store app
        final marketUri = Uri.parse('market://details?id=$androidPackageName');
        if (await _tryLaunch(marketUri)) {
          return true;
        }

        // 2) Play Store web
        final webUri = Uri.parse(
            'https://play.google.com/store/apps/details?id=$androidPackageName');
        if (await _tryLaunchWeb(webUri,
            preferInAppBrowser: preferInAppBrowser)) {
          return true;
        }

        return false;
      }

      if (Platform.isIOS) {
        // 1) App Store app (no Safari hop)
        // Note: itms-apps is the commonly used scheme; the full URL form is reliable.
        final itmsUri = Uri.parse('itms-apps://apps.apple.com/app/id$iosAppId');
        if (await _tryLaunch(itmsUri)) {
          return true;
        }

        // 2) App Store web
        final webUri = Uri.parse('https://apps.apple.com/app/id$iosAppId');
        if (await _tryLaunchWeb(webUri,
            preferInAppBrowser: preferInAppBrowser)) {
          return true;
        }

        return false;
      }

      // Other platforms (Web/Desktop)
      // You can choose a default web URL, or just return false.
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _tryLaunch(Uri uri) async {
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  static Future<bool> _tryLaunchWeb(
    Uri uri, {
    required bool preferInAppBrowser,
  }) async {
    if (!await canLaunchUrl(uri)) return false;

    // In-app browser can be useful if external app launch is blocked.
    if (preferInAppBrowser) {
      final ok = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      if (ok) return true;
    }

    // External browser as the most reliable fallback.
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
