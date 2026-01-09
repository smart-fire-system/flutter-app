import 'package:fire_alarm_system/l10n/app_localizations.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomLoading extends StatefulWidget {
  final String? text;
  const CustomLoading({super.key, this.text});

  @override
  CustomLoadingState createState() => CustomLoadingState();
}

class CustomLoadingState extends State<CustomLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _animation,
                child: Image.asset(
                  'assets/images/logo/2.jpg',
                  width: 100,
                  height: 100,
                ),
              ),
              if (widget.text != null)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0),
                  child: Text(
                    widget.text!,
                    style: CustomStyle.largeText30,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppLoading {
  static final AppLoading _instance = AppLoading._internal();
  final Map<AppScreen, BuildContext?> _appScreenContexts = {
    for (var screen in AppScreen.values) screen: null,
  };
  AppLoading._internal();
  factory AppLoading() {
    return _instance;
  }
  void dismiss({required BuildContext context, required AppScreen screen}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_appScreenContexts[screen] != null) {
        if (_appScreenContexts[screen]!.mounted) {
          Navigator.pop(_appScreenContexts[screen]!);
        }
        _appScreenContexts[screen] = null;
      }
    });
  }

  void show({
    required BuildContext context,
    required AppScreen screen,
    String? title,
    String type = 'loading',
  }) {
    if (_appScreenContexts[screen] == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            _appScreenContexts[screen] = context;
            final l10n = AppLocalizations.of(context)!;
            return PopScope(
              canPop: false,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width < 500
                      ? MediaQuery.of(context).size.width * 0.8
                      : 400,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height < 800
                        ? MediaQuery.of(context).size.height * 0.7
                        : 400,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Image.asset(
                        'assets/gif/$type.gif',
                        height: 75,
                      ),
                      Center(
                        child: Text(
                          title ?? l10n.wait_while_loading,
                          style: CustomStyle.largeText25B,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      });
    }
  }
}
