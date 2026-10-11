import 'package:flutter/material.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const films = '/films';
  static const events = '/events';
  static const offers = '/offers';
  static const account = '/account';
  static const cinemas = '/cinemas';
  static const tickets = '/tickets';

  static const primary = [films, events, offers, account];
}

class PrimaryNavigationArguments {
  const PrimaryNavigationArguments({required this.fromIndex});

  final int fromIndex;
}

void openPrimaryDestination(
  BuildContext context, {
  required int currentIndex,
  required int destinationIndex,
}) {
  if (currentIndex == destinationIndex) return;
  Navigator.of(context).pushReplacementNamed(
    AppRoutes.primary[destinationIndex],
    arguments: PrimaryNavigationArguments(fromIndex: currentIndex),
  );
}

String? routeForDrawerDestination(String destination) {
  return switch (destination) {
    'Profile' => AppRoutes.account,
    'My bookings' => AppRoutes.tickets,
    _ => null,
  };
}
