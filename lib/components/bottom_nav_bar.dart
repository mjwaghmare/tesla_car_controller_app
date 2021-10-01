import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constraints.dart';

class TeslaBottomNavBar extends StatelessWidget {
  const TeslaBottomNavBar({
    Key key,
    @required this.selectedTab,
    @required this.onTap,
  }) : super(key: key);

  final int selectedTab;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        onTap: onTap,
        currentIndex: selectedTab,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: List.generate(
          navItemSrc.length,
          (index) => BottomNavigationBarItem(
            icon: SvgPicture.asset(
              navItemSrc[index],
              color: selectedTab == index ? primaryColor : Colors.white54,
            ),
            label: "",
          ),
        ));
  }
}

List<String> navItemSrc = [
  "assets/icons/Lock.svg",
  "assets/icons/Charge.svg",
  "assets/icons/Temp.svg",
  "assets/icons/Tyre.svg",
];
