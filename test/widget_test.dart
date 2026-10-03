import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:savannah_cinemas_app/src/savannah_app.dart';

void main() {
  testWidgets('unrestricted sign in opens home', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const SavannahApp());

    expect(find.text('Welcome\nback'), findsOneWidget);
    expect(find.text('Continue as guest'), findsOneWidget);

    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pumpAndSettle();

    expect(find.text('Trending now'), findsOneWidget);
    expect(find.text('Book tickets'), findsOneWidget);
    expect(find.byKey(const Key('movieSearch')), findsOneWidget);
    expect(find.byType(BackdropFilter), findsOneWidget);

    final homeScaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(homeScaffold.extendBody, isTrue);

    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();

    expect(find.text('Now showing'), findsOneWidget);
    expect(find.text('My bookings'), findsOneWidget);
    expect(find.text('My trophies'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, 'Cinemas'));
    await tester.pumpAndSettle();

    expect(find.text('Near you'), findsOneWidget);
    expect(find.text('Accra Mall Cinema'), findsOneWidget);
    expect(find.text('Showtimes'), findsWidgets);

    await tester.tap(find.text('Tickets'));
    await tester.pumpAndSettle();

    expect(find.text('Your next show'), findsOneWidget);
    expect(find.text('SVN-9M2XD'), findsOneWidget);
    expect(find.text('View ticket'), findsOneWidget);

    await tester.tap(find.text('Past'));
    await tester.pumpAndSettle();
    expect(find.text('Your ticket stubs'), findsOneWidget);
    expect(find.text('Kente Kings'), findsOneWidget);
  });
}
