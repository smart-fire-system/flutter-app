import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/utils/localization_util.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: CustomStyle.appBarText,
      ),
      backgroundColor: CustomStyle.redDark,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      leading: leading,
      //leading: Padding(
      //  padding: const EdgeInsets.all(8.0),
      //  child: Image.asset(
      //    'assets/images/logo/2.png',
      //  ),
      //),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.language, color: Colors.white),
          onPressed: () {
            LocalizationUtil.showEditLanguageDialog(context);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
