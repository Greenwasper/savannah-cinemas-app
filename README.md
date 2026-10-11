# Savannah Cinemas

A Flutter mobile application prototype for discovering films, browsing cinema
experiences and managing a Savannah Cinemas account.

![Savannah Cinemas app icon](assets/branding/savannah-app-icon-1024.png)

## Current features

- Sign-in, guest access and account creation flows
- Registration validation for names, email, matching passwords and Terms acceptance
- Film discovery home screen with search, featured content and movie cards
- Cinema selector for Accra Mall, Tema and Kumasi City
- Bottom navigation for Films, Events, Offers and Account
- Direction-aware bottom-navigation transitions
- Account drawer with bookings, history, trophies, watchlist and settings links
- Cinema results with format filters and search
- Upcoming and past ticket views
- Responsive dark interface with frosted navigation
- Generated Android and iOS launcher icons

Events, Offers and several account actions currently use prototype or
coming-soon states.

## Requirements

- Flutter SDK with Dart 3.12 or newer
- Xcode with iOS platform support for iOS development
- Android Studio or the Android SDK for Android development
- CocoaPods for native iOS dependencies

Check your local toolchain with:

```sh
flutter doctor
```

## Getting started

Clone the repository and install its packages:

```sh
git clone git@github.com:Greenwasper/savannah-cinemas-app.git
cd savannah-cinemas-app
flutter pub get
```

List available devices and run the application:

```sh
flutter devices
flutter run
```

To use VS Code, open the project directory, select a Flutter device from the
status bar or Command Palette, and start the `Savannah Cinemas` launch
configuration. The simulator identifier in `.vscode/launch.json` is
machine-specific and may need to be changed.

## Quality checks

Run static analysis and the widget tests before submitting changes:

```sh
flutter analyze
flutter test
```

The widget tests cover account creation, primary navigation and its transition
directions, the cinema selector, drawer navigation, and the map-free cinema
results layout.

## Launcher icons

The source artwork is stored at:

```text
assets/branding/savannah-app-icon-1024.png
```

The project uses `flutter_launcher_icons` to create the native Android and iOS
icon sets. Regenerate them after changing the source image:

```sh
flutter pub get
dart run flutter_launcher_icons
```

## Project structure

```text
lib/
├── main.dart
└── src/
    ├── app_routes.dart
    ├── savannah_app.dart
    ├── theme.dart
    ├── screens/
    │   ├── cinemas_screen.dart
    │   ├── destination_screen.dart
    │   ├── home_screen.dart
    │   ├── login_screen.dart
    │   └── tickets_screen.dart
    └── widgets/
        ├── brand_mark.dart
        ├── frosted_bottom_navigation.dart
        └── savannah_menu_drawer.dart
```

## Prototype data

This version does not yet connect to the production Cinema-Booking backend.

- Film and cinema information is currently declared in Dart source files.
- Poster artwork is loaded from remote TMDB image URLs and requires a network connection.
- Authentication and account creation are UI flows only; credentials are not submitted or stored.
- The selected cinema is retained for the current application session only.

These should be replaced with API-backed repositories, persistent preferences
and production authentication before release.

## Release notes

- iOS deployment target: 15.0
- iOS bundle identifier: `com.savannahcinemas.savannahCinemasApp`
- Android application ID: `com.savannahcinemas.savannah_cinemas_app`
- Display name: Savannah Cinemas

Before publishing Android builds, replace the debug signing configuration in
`android/app/build.gradle.kts` with a secure release signing configuration.

For iOS distribution, open `ios/Runner.xcworkspace` in Xcode, select the
`Runner` scheme and upload an archive through App Store Connect.
