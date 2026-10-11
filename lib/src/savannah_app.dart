import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'screens/cinemas_screen.dart';
import 'screens/destination_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/tickets_screen.dart';
import 'theme.dart';

class SavannahApp extends StatelessWidget {
  const SavannahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Savannah Cinemas',
      debugShowCheckedModeBanner: false,
      theme: SavannahTheme.dark,
      home: const LoginScreen(),
      routes: {
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.cinemas: (_) => const CinemasScreen(),
        AppRoutes.tickets: (_) => const TicketsScreen(),
      },
      onGenerateRoute: _buildPrimaryRoute,
    );
  }

  Route<void>? _buildPrimaryRoute(RouteSettings settings) {
    final (page, destinationIndex) = switch (settings.name) {
      AppRoutes.films => (const HomeScreen(), 0),
      AppRoutes.events => (
        const DestinationScreen(destination: MainDestination.events),
        1,
      ),
      AppRoutes.offers => (
        const DestinationScreen(destination: MainDestination.offers),
        2,
      ),
      AppRoutes.account => (
        const DestinationScreen(destination: MainDestination.account),
        3,
      ),
      _ => (null, -1),
    };

    if (page == null) return null;

    final arguments = settings.arguments;
    final fromIndex = arguments is PrimaryNavigationArguments
        ? arguments.fromIndex
        : null;

    return PageRouteBuilder<void>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        if (fromIndex == null) {
          return FadeTransition(opacity: animation, child: child);
        }

        final entersFromRight = destinationIndex > fromIndex;
        final offset = Offset(entersFromRight ? 1 : -1, 0);
        final position = animation.drive(
          Tween<Offset>(
            begin: offset,
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutCubic)),
        );
        return SlideTransition(
          key: const Key('primaryTabSlideTransition'),
          position: position,
          child: child,
        );
      },
    );
  }
}
