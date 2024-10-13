import 'package:flutter/material.dart';
import 'package:fire_alarm_system/utils/styles.dart';

class CustomNoInternet extends StatelessWidget {
  const CustomNoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fire Alarm System',
      home: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.wifi_off,
                    size: 50,
                  ),
                  Text(
                    'No Internet Connection.',
                    style: CustomStyle.mediumText,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
