import 'package:fire_alarm_system/models/user.dart';
import 'package:fire_alarm_system/utils/enums.dart';
import 'package:fire_alarm_system/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fire_alarm_system/generated/l10n.dart';

enum CustomBottomNavigatorItems {
  profile,
  reports,
  system,
  complaints,
  users,
}

class CustomBottomNavigatorItemData {
  CustomBottomNavigatorItems item;
  IconData icon;
  String label;

  CustomBottomNavigatorItemData({
    required this.item,
    required this.icon,
    required this.label,
  });
}

class CustomBottomNavigator extends StatefulWidget {
  final CustomBottomNavigatorItems selectedItem;
  final User user;
  final void Function(CustomBottomNavigatorItems item)? onItemClick;
  const CustomBottomNavigator({
    super.key,
    required this.selectedItem,
    this.onItemClick,
    required this.user,
  });

  @override
  CustomBottomNavigatorState createState() => CustomBottomNavigatorState();
}

class CustomBottomNavigatorState extends State<CustomBottomNavigator> {
  void _defaultOnItemClick(CustomBottomNavigatorItems item) {
    print("Default onItemClick triggered for $item");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<CustomBottomNavigatorItemData> items = [
      CustomBottomNavigatorItemData(
          item: CustomBottomNavigatorItems.profile,
          icon: Icons.person,
          label: S.of(context).profile),
      CustomBottomNavigatorItemData(
          item: CustomBottomNavigatorItems.reports,
          icon: Icons.article,
          label: S.of(context).reports),
      CustomBottomNavigatorItemData(
          item: CustomBottomNavigatorItems.system,
          icon: Icons.bar_chart_outlined,
          label: S.of(context).system),
      CustomBottomNavigatorItemData(
          item: CustomBottomNavigatorItems.complaints,
          icon: Icons.support_agent,
          label: S.of(context).complaints),
      CustomBottomNavigatorItemData(
          item: CustomBottomNavigatorItems.users,
          icon: Icons.group,
          label: S.of(context).users),
    ];
    if (widget.user.role == UserRole.client) {
      items.removeAt(CustomBottomNavigatorItems.users.index);
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => widget.onItemClick!(entry.value.item),
            child: _buildNavItem(entry.value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNavItem(CustomBottomNavigatorItemData itemData) {
    final isSelected = widget.selectedItem == itemData.item;
    if (itemData.item == CustomBottomNavigatorItems.users &&
        widget.user.role == UserRole.admin) {
      itemData.label =
          '${S.of(context).users} ${S.of(context).and} ${S.of(context).branches}';
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            itemData.icon,
            size: isSelected ? 28 : 24,
            color: isSelected ? CustomStyle.redDark : CustomStyle.greyLight,
          ),
          const SizedBox(height: 4),
          Text(
            itemData.label,
            style: isSelected
                ? CustomStyle.navBarTextHighLighted
                : CustomStyle.navBarText,
          ),
        ],
      ),
    );
  }
}
