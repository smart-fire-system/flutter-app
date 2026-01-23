import 'package:fire_alarm_system/models/app_version.dart';
import 'package:fire_alarm_system/utils/open_store.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_shimmer.dart';
import 'dart:io';
import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

Widget buildUpdateNeeded(BuildContext context, AppVersionData appVersionData) {
  return UpdateNeededScreen(appVersionData: appVersionData);
}

class UpdateNeededScreen extends StatefulWidget {
  final AppVersionData appVersionData;
  const UpdateNeededScreen({
    super.key,
    required this.appVersionData,
  });

  @override
  State<UpdateNeededScreen> createState() => _UpdateNeededScreenState();
}

class _UpdateNeededScreenState extends State<UpdateNeededScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoShimmerController;

  @override
  void initState() {
    super.initState();
    _logoShimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _logoShimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appVersionData = widget.appVersionData;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode.toLowerCase() == 'ar';

    final info = Platform.isAndroid
        ? appVersionData.androidInfo
        : appVersionData.iosInfo;
    final updateRequiredByVersion = Platform.isAndroid
        ? appVersionData.isAndroidUpdateRequired
        : appVersionData.isIosUpdateRequired;
    final appUnavailable = !info.isAppAvailable;

    final isUnavailableUi = appUnavailable;
    final isUpdateRequiredUi = !isUnavailableUi && updateRequiredByVersion;

    final title = isUpdateRequiredUi
        ? l10n.update_needed_title_update_required
        : l10n.update_needed_title_unavailable;

    final messageFromServer =
        (isArabic ? info.updateMessageAr : info.updateMessageEn).trim();
    final fallbackMessage = isUpdateRequiredUi
        ? l10n.update_needed_message_update_required
        : l10n.update_needed_message_unavailable;
    final bodyMessage =
        messageFromServer.isNotEmpty ? messageFromServer : fallbackMessage;

    final heroIcon = isUpdateRequiredUi
        ? Icons.system_update_alt_rounded
        : (isUnavailableUi
            ? Icons.construction_rounded
            : Icons.warning_rounded);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _logoShimmerController,
                    builder: (context, _) {
                      return Hero(
                        tag: 'appLogoHero',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AppShimmer(
                            progress: _logoShimmerController.value,
                            child: Image.asset(
                              'assets/images/logo/1.png',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Icon(heroIcon, color: CustomStyle.redDark, size: 100),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: CustomStyle.largeText25B,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: CustomStyle.greySuperLight),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          bodyMessage,
                          style:
                              CustomStyle.smallTextGrey.copyWith(fontSize: 16),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (isUpdateRequiredUi) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: openStore,
                            icon: const Icon(Icons.update_rounded),
                            label: Text(
                              l10n.notifications_update_application,
                              style: CustomStyle.normalButtonTextSmallWhite,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomStyle.redDark,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
