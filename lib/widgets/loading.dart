import 'package:flutter/material.dart';
import 'package:fire_alarm_system/generated/l10n.dart';
import 'package:fire_alarm_system/utils/styles.dart';

class CustomLoading extends StatelessWidget {
  final bool? noText;
  const CustomLoading({super.key, this.noText});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/loading.gif',
                  fit: BoxFit.contain,
                  width: 200,
                ),
                if (noText == null || noText == false)
                  Text(
                    S.of(context).wait_while_loading,
                    style: CustomStyle.mediumText,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
