import 'dart:ui';

import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/utils/app_version.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:fire_alarm_system/widgets/app_shimmer.dart';
import 'package:fire_alarm_system/widgets/app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppDeveloperScreen extends StatefulWidget {
  const AboutAppDeveloperScreen({super.key});

  static const String developerName = 'Ahmed Hassan';
  static const String developerEmail = 'ahmadmhasann@gmail.com';
  static const String developerPhone = '+201024242768';
  static const String developerWebsite = 'https://ahmedhassandev.com';
  static const String developerLinkedIn =
      'https://www.linkedin.com/in/ahmadmhasann';

  @override
  State<AboutAppDeveloperScreen> createState() =>
      _AboutAppDeveloperScreenState();
}

class _AboutAppDeveloperScreenState extends State<AboutAppDeveloperScreen>
    with TickerProviderStateMixin {
  late final AnimationController _enterController;
  late final AnimationController _bgController;

  late final Animation<double> _pageFade;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerScale;

  @override
  void initState() {
    super.initState();

    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _pageFade = CurvedAnimation(
      parent: _enterController,
      curve: Curves.easeOutCubic,
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _headerScale = Tween<double>(begin: 0.98, end: 1.0).animate(
      CurvedAnimation(
        parent: _enterController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _enterController.forward();
  }

  Animation<double> _reveal(Interval interval) {
    return CurvedAnimation(parent: _enterController, curve: interval);
  }

  @override
  void dispose() {
    _enterController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAndroid =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    final version = isAndroid
        ? '$androidAppVersion\nBuild Number: $androidBuildNumber'
        : iosAppVersion;

    final platformText = kIsWeb
        ? 'Web'
        : switch (defaultTargetPlatform) {
            TargetPlatform.android => 'Android',
            TargetPlatform.iOS => 'iOS',
            TargetPlatform.macOS => 'macOS',
            TargetPlatform.windows => 'Windows',
            TargetPlatform.linux => 'Linux',
            TargetPlatform.fuchsia => 'Fuchsia',
          };

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(title: l10n.about_app_and_developer),
      body: AnimatedBuilder(
        animation: Listenable.merge([_enterController, _bgController]),
        builder: (context, _) {
          return Stack(
            children: [
              _AnimatedGradientBackground(t: _bgController.value),
              // subtle glow layer
              Positioned.fill(
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.22,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0.0, -0.6),
                          radius: 1.1,
                          colors: [
                            const Color(0xFFEF4444).withValues(alpha: 0.55),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              FadeTransition(
                opacity: _pageFade,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SlideTransition(
                        position: _headerSlide,
                        child: ScaleTransition(
                          scale: _headerScale,
                          child: _HeroLogoCard(
                            child: Hero(
                              tag: 'appLogoHero',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: AppShimmer(
                                  progress: _bgController.value,
                                  child: Image.asset(
                                    'assets/images/logo/1.png',
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _AnimatedIn(
                        controller: _enterController,
                        interval: const Interval(0.10, 0.75,
                            curve: Curves.easeOutCubic),
                        child: Text(
                          l10n.about_app_and_developer,
                          style: CustomStyle.largeTextBRed,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _AnimatedIn(
                        controller: _enterController,
                        interval: const Interval(0.20, 0.90,
                            curve: Curves.easeOutCubic),
                        child: _GlassSectionCard(
                          title: l10n.about_app_info_title,
                          children: [
                            _AnimatedIn(
                              controller: _enterController,
                              interval: const Interval(0.26, 0.92,
                                  curve: Curves.easeOutCubic),
                              child: _InfoRow(
                                icon: Icons.apps_rounded,
                                label: l10n.app_name,
                                value: l10n.app_name,
                                isValueSelectable: true,
                                reveal: _reveal(
                                  const Interval(0.30, 0.55,
                                      curve: Curves.easeOutCubic),
                                ),
                              ),
                            ),
                            _AnimatedIn(
                              controller: _enterController,
                              interval: const Interval(0.30, 0.95,
                                  curve: Curves.easeOutCubic),
                              child: _InfoRow(
                                icon: Icons.info_outline_rounded,
                                label: l10n.about_version_label,
                                value: version,
                                isValueSelectable: true,
                                reveal: _reveal(
                                  const Interval(0.34, 0.62,
                                      curve: Curves.easeOutCubic),
                                ),
                              ),
                            ),
                            _AnimatedIn(
                              controller: _enterController,
                              interval: const Interval(0.32, 0.96,
                                  curve: Curves.easeOutCubic),
                              child: _InfoRow(
                                icon: Icons.devices_rounded,
                                label: l10n.about_platform_label,
                                value: platformText,
                                isValueSelectable: true,
                                reveal: _reveal(
                                  const Interval(0.36, 0.66,
                                      curve: Curves.easeOutCubic),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _AnimatedIn(
                        controller: _enterController,
                        interval: const Interval(0.34, 0.98,
                            curve: Curves.easeOutCubic),
                        child: _GlassSectionCard(
                          title: l10n.about_developer_info_title,
                          children: [
                            _AnimatedIn(
                              controller: _enterController,
                              interval: const Interval(0.38, 1.00,
                                  curve: Curves.easeOutCubic),
                              child: _InfoRow(
                                icon: Icons.person_rounded,
                                label: l10n.about_developer_name_label,
                                value: AboutAppDeveloperScreen.developerName,
                                isValueSelectable: true,
                                reveal: _reveal(
                                  const Interval(0.44, 0.70,
                                      curve: Curves.easeOutCubic),
                                ),
                              ),
                            ),
                            _AnimatedIn(
                              controller: _enterController,
                              interval: const Interval(0.42, 1.00,
                                  curve: Curves.easeOutCubic),
                              child: _InfoRow(
                                icon: Icons.email_rounded,
                                label: l10n.about_developer_email_label,
                                value: AboutAppDeveloperScreen.developerEmail,
                                isValueSelectable: true,
                                reveal: _reveal(
                                  const Interval(0.48, 0.78,
                                      curve: Curves.easeOutCubic),
                                ),
                                onTap: () => _launchUri(
                                  Uri.parse(
                                      'mailto:${AboutAppDeveloperScreen.developerEmail}'),
                                ),
                              ),
                            ),
                            _AnimatedIn(
                              controller: _enterController,
                              interval: const Interval(0.46, 1.00,
                                  curve: Curves.easeOutCubic),
                              child: _InfoRow(
                                icon: Icons.phone_rounded,
                                label: l10n.about_developer_phone_label,
                                value: AboutAppDeveloperScreen.developerPhone,
                                isValueSelectable: true,
                                reveal: _reveal(
                                  const Interval(0.52, 0.84,
                                      curve: Curves.easeOutCubic),
                                ),
                                onTap: () => _launchUri(
                                  Uri.parse(
                                      'tel:${AboutAppDeveloperScreen.developerPhone}'),
                                ),
                              ),
                            ),
                            _AnimatedIn(
                              controller: _enterController,
                              interval: const Interval(0.50, 1.00,
                                  curve: Curves.easeOutCubic),
                              child: _InfoRow(
                                icon: Icons.language_rounded,
                                label: l10n.about_developer_website_label,
                                value: AboutAppDeveloperScreen.developerWebsite,
                                isValueSelectable: true,
                                reveal: _reveal(
                                  const Interval(0.56, 0.90,
                                      curve: Curves.easeOutCubic),
                                ),
                                onTap: () => _launchUri(
                                  Uri.parse(
                                      AboutAppDeveloperScreen.developerWebsite),
                                ),
                              ),
                            ),
                            _AnimatedIn(
                              controller: _enterController,
                              interval: const Interval(0.54, 1.00,
                                  curve: Curves.easeOutCubic),
                              child: _InfoRow(
                                icon: Icons.badge_outlined,
                                label: l10n.about_developer_linkedin_label,
                                value:
                                    AboutAppDeveloperScreen.developerLinkedIn,
                                isValueSelectable: true,
                                reveal: _reveal(
                                  const Interval(0.60, 0.94,
                                      curve: Curves.easeOutCubic),
                                ),
                                onTap: () => _launchUri(
                                  Uri.parse(AboutAppDeveloperScreen
                                      .developerLinkedIn),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static Future<void> _launchUri(Uri uri) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      // Intentionally ignore failures (e.g., platform doesn't support).
    }
  }
}

class _AnimatedGradientBackground extends StatelessWidget {
  final double t;
  const _AnimatedGradientBackground({required this.t});

  @override
  Widget build(BuildContext context) {
    double wrapHue(double hue) => hue % 360.0;

    final a = HSVColor.fromAHSV(1, wrapHue(355 + 30 * t), 0.60, 0.95).toColor();
    final b = HSVColor.fromAHSV(1, wrapHue(210 + 40 * t), 0.55, 0.95).toColor();
    final c = HSVColor.fromAHSV(1, wrapHue(265 + 35 * t), 0.50, 0.95).toColor();

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              a.withValues(alpha: 0.18),
              b.withValues(alpha: 0.14),
              c.withValues(alpha: 0.12),
              const Color(0xFFF8F9FA),
            ],
            stops: const [0.0, 0.35, 0.7, 1.0],
          ),
        ),
      ),
    );
  }
}

class _HeroLogoCard extends StatelessWidget {
  final Widget child;
  const _HeroLogoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _AnimatedIn extends StatelessWidget {
  final AnimationController controller;
  final Interval interval;
  final Widget child;

  const _AnimatedIn({
    required this.controller,
    required this.interval,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(parent: controller, curve: interval);
    final slide = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(animation);
    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }
}

class _GlassSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _GlassSectionCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.70),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.55),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: CustomStyle.mediumTextBRed),
                const SizedBox(height: 12),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isValueSelectable;
  final VoidCallback? onTap;
  final Animation<double>? reveal;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isValueSelectable,
    this.onTap,
    this.reveal,
  });

  @override
  Widget build(BuildContext context) {
    final isTappable = onTap != null;
    final valueWidget = _AnimatedValueText(
      text: value,
      style: CustomStyle.smallTextGrey,
      reveal: reveal,
      // If this row opens a link, make taps reliably trigger the row action.
      // (SelectableText can otherwise capture taps.)
      selectableWhenComplete: isTappable ? false : isValueSelectable,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CustomStyle.redDark.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: CustomStyle.redDark, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AbsorbPointer(
                absorbing: isTappable,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: CustomStyle.smallTextB),
                    const SizedBox(height: 2),
                    valueWidget,
                  ],
                ),
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.open_in_new_rounded,
                size: 18,
                color: Colors.grey.shade500,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnimatedValueText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Animation<double>? reveal;
  final bool selectableWhenComplete;

  const _AnimatedValueText({
    required this.text,
    required this.style,
    required this.reveal,
    required this.selectableWhenComplete,
  });

  @override
  Widget build(BuildContext context) {
    if (reveal == null) {
      return selectableWhenComplete
          ? SelectableText(text, style: style)
          : Text(text, style: style);
    }

    return AnimatedBuilder(
      animation: reveal!,
      builder: (context, _) {
        final t = reveal!.value.clamp(0.0, 1.0);
        final chars = text.characters;
        final len = chars.length;
        final shown = (len * t).floor().clamp(0, len);
        final partial = chars.take(shown).toString();
        final done = t >= 0.999;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: done
              ? (selectableWhenComplete
                  ? SelectableText(
                      text,
                      style: style,
                      key: const ValueKey('doneSelectable'),
                    )
                  : Text(text, style: style, key: const ValueKey('doneText')))
              : Text(partial, style: style, key: const ValueKey('partialText')),
        );
      },
    );
  }
}
