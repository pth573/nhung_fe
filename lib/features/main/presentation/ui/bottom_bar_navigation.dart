import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/tab_model.dart';
import '../provider/tab_provider.dart';
import 'bottom_navigation_item.dart';

class BottomBarNavigation extends ConsumerWidget {
  const BottomBarNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TabEnum tab = ref.watch(tabProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            width: 1,
            color: Color(0xFFDDDDDD),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BottomNavigationItem(
            tab: TabEnum.home,
            iconPath: tab == TabEnum.home
                ? 'assets/icons/icon_home_bold.svg'
                : 'assets/icons/icon_home.svg',
            isSelected: tab == TabEnum.home
          ),
          BottomNavigationItem(
            tab: TabEnum.map,
            iconPath: tab == TabEnum.map
                ? 'assets/icons/icon_map_bold.svg'
                : 'assets/icons/icon_map.svg',
            isSelected: tab == TabEnum.map
          ),
          BottomNavigationItem(
              tab: TabEnum.alert,
              iconPath: tab == TabEnum.alert
                  ? 'assets/icons/icon_alert_bold.svg'
                  : 'assets/icons/icon_alert.svg',
              isSelected: tab == TabEnum.alert
          ),
          BottomNavigationItem(
            tab: TabEnum.trip,
            iconPath: 'assets/icons/icon_trip.svg',
            isSelected: tab == TabEnum.trip
          ),
        ],
      ),
    );
  }
}
