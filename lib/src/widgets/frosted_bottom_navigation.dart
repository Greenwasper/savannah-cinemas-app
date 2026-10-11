import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedBottomNavigation extends StatelessWidget {
  const FrostedBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Color(0xA6191923),
            border: Border(
              top: BorderSide(color: Color(0x24353549), width: .8),
            ),
          ),
          child: NavigationBar(
            height: 78,
            elevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            indicatorColor: const Color(0x2EEDAA3B),
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.local_movies_outlined),
                selectedIcon: Icon(Icons.local_movies_rounded),
                label: 'Films',
              ),
              NavigationDestination(
                icon: Icon(Icons.star_outline_rounded),
                selectedIcon: Icon(Icons.star_rounded),
                label: 'Events',
              ),
              NavigationDestination(
                icon: Icon(Icons.local_offer_outlined),
                selectedIcon: Icon(Icons.local_offer_rounded),
                label: 'Offers',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
