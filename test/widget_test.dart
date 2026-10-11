import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:savannah_cinemas_app/src/savannah_app.dart';
import 'package:savannah_cinemas_app/src/screens/cinemas_screen.dart';
import 'package:savannah_cinemas_app/src/theme.dart';

void main() {
  Future<void> setPhoneSize(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }

  testWidgets('guest can use the revised primary and account navigation', (
    tester,
  ) async {
    await setPhoneSize(tester);
    await tester.pumpWidget(const SavannahApp());

    expect(find.text('Welcome\nback'), findsOneWidget);
    expect(find.text('Continue as guest'), findsOneWidget);

    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pumpAndSettle();

    expect(find.text('Trending now'), findsOneWidget);
    expect(find.text('Book tickets'), findsOneWidget);
    expect(find.byKey(const Key('movieSearch')), findsOneWidget);
    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(find.text('Films'), findsOneWidget);
    expect(find.text('Events'), findsOneWidget);
    expect(find.text('Offers'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);

    await tester.tap(find.byKey(const Key('cinemaSelector')));
    await tester.pumpAndSettle();
    expect(find.text('Choose your cinema'), findsOneWidget);
    expect(find.text('Accra Mall Cinema'), findsOneWidget);
    expect(find.text('Tema Shopping Cinema'), findsOneWidget);
    expect(find.text('Kumasi City Cinema'), findsOneWidget);

    await tester.tap(find.byKey(const Key('cinemaChoice-tema')));
    await tester.pumpAndSettle();
    expect(find.text('Tema'), findsOneWidget);

    await tester.tap(find.text('Offers'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    var transitions = tester.widgetList<SlideTransition>(
      find.byKey(const Key('primaryTabSlideTransition')),
    );
    expect(
      transitions.any((transition) => transition.position.value.dx > 0),
      isTrue,
    );
    await tester.pumpAndSettle();
    expect(find.text('A little extra'), findsOneWidget);

    await tester.tap(find.text('Films'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    transitions = tester.widgetList<SlideTransition>(
      find.byKey(const Key('primaryTabSlideTransition')),
    );
    expect(
      transitions.any((transition) => transition.position.value.dx < 0),
      isTrue,
    );
    await tester.pumpAndSettle();
    expect(find.text('Tema'), findsOneWidget);

    final homeScaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(homeScaffold.extendBody, isTrue);

    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();

    expect(find.text('Cinema lover'), findsOneWidget);
    expect(find.text('My bookings'), findsOneWidget);
    expect(find.text('My trophies'), findsOneWidget);
    expect(find.text('Now showing'), findsNothing);
    expect(find.widgetWithText(ListTile, 'Cinemas'), findsNothing);

    await tester.tap(find.widgetWithText(ListTile, 'My bookings'));
    await tester.pumpAndSettle();

    expect(find.text('Your next show'), findsOneWidget);
    expect(find.text('SVN-9M2XD'), findsOneWidget);

    await tester.tap(find.text('Events'));
    await tester.pumpAndSettle();
    expect(find.text('More than movies'), findsOneWidget);

    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cinema lover'));
    await tester.pumpAndSettle();

    expect(find.text('Your account'), findsNWidgets(2));
    expect(find.text('Bronze member  •  0 points'), findsOneWidget);
  });

  testWidgets('create account collects and validates all required details', (
    tester,
  ) async {
    await setPhoneSize(tester);
    await tester.pumpWidget(const SavannahApp());

    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Create your\naccount'), findsOneWidget);
    expect(find.byKey(const Key('firstNameField')), findsOneWidget);
    expect(find.byKey(const Key('lastNameField')), findsOneWidget);
    expect(find.byKey(const Key('emailField')), findsOneWidget);
    expect(find.byKey(const Key('passwordField')), findsOneWidget);
    expect(find.byKey(const Key('confirmPasswordField')), findsOneWidget);
    expect(find.text('Terms and Conditions'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('firstNameField')), 'Ama');
    await tester.enterText(find.byKey(const Key('lastNameField')), 'Mensah');
    await tester.enterText(
      find.byKey(const Key('emailField')),
      'ama@example.com',
    );
    await tester.enterText(find.byKey(const Key('passwordField')), 'cinema123');
    await tester.enterText(
      find.byKey(const Key('confirmPasswordField')),
      'cinema123',
    );

    await tester.ensureVisible(find.byKey(const Key('termsCheckbox')));
    await tester.tap(find.byKey(const Key('termsCheckbox')));
    await tester.pump();

    await tester.ensureVisible(find.byKey(const Key('signInButton')));
    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pumpAndSettle();

    expect(find.text('Trending now'), findsOneWidget);
  });

  testWidgets('cinema results follow filters without the map', (tester) async {
    await setPhoneSize(tester);
    await tester.pumpWidget(
      MaterialApp(theme: SavannahTheme.dark, home: const CinemasScreen()),
    );

    expect(find.text('Nearest'), findsOneWidget);
    expect(find.text('Near you'), findsOneWidget);
    expect(find.text('Accra Mall Cinema'), findsOneWidget);
    expect(find.text('Greater Accra'), findsNothing);
  });
}
