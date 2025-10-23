# User App (Flutter) - Documentation

This document provides a comprehensive, user-focused guide for the `user` Flutter application in this repository. It explains the app's purpose, how to run and build it, configuration for connecting to the backend, and guidance for QA and troubleshooting.

---

## Table of Contents

- Overview
- Key Features
- Prerequisites
- Project Structure
- Installation
- Running the App (development)
- Building for Release
- Configuration & Environment
- Authentication flow
- Data & API integration
- Assets and theming
- Localization
- Testing
- CI / Release guidance
- Troubleshooting
- Feedback & Contributing
- License

---

## Overview

The `user` app is the primary mobile (and optionally web/desktop) client for learners. It provides:

- Browsing and enrolling in courses
- Viewing lessons and course materials
- Taking quizzes and viewing results
- Tracking learning progress and history
- Viewing badges, ranks, and leaderboards
- Receiving notifications
- Managing user profile and settings

This app is designed to interact with the EdTech backend (Appwrite Function) via RESTful endpoints. The backend handles authentication, data storage, quiz grading, notifications, and other server-side logic.

---

## Key Features

- Responsive UI built with Flutter
- Offline-friendly caching strategies (if implemented)
- Secure authentication (Appwrite / token-based)
- Rich media support (videos, PDFs, images)
- Interactive quizzes with automatic grading
- Progress tracking and progress visualizations
- Notifications and in-app messages

---

## Prerequisites

Before you start, make sure you have:

- Flutter SDK (>= 3.0)
- Dart SDK (bundled with Flutter)
- Android SDK (for Android builds)
- Xcode (for iOS builds on macOS)
- Chrome (for web builds)
- Optional: Flutter version manager (fvm)

Verify installation:

```powershell
flutter --version
flutter doctor
```

---

## Project Structure

```
user/
├── android/          # Android project files
├── ios/              # iOS project files
├── lib/              # Main Dart source
│   ├── main.dart     # App entrypoint
│   ├── app/          # App wiring: core, data, modules, routes
│   ├── data/         # API clients, models, repositories
│   └── modules/      # Feature modules: courses, lessons, quizzes
├── assets/           # Images, fonts, media
├── test/             # Unit and widget tests
├── pubspec.yaml
└── README.md         # This file
```

Notes:

- `lib/app` contains high-level wiring: dependency injection, routing, and theming.
- `lib/data` is where the app integrates with the backend API. Check `api_client.dart` or similar files for endpoint usage.
- `lib/modules` holds features such as `courses`, `lessons`, `quizzes`, `profile`.

---

## Installation

1. Change directory to the user app:

```powershell
cd frontend/user
```

2. Fetch dependencies:

```powershell
flutter pub get
```

3. (Optional) Use `fvm` if project uses Flutter version manager:

```powershell
fvm install
fvm use
fvm flutter pub get
```

---

## Running the App (Development)

Run on connected device or emulator:

```powershell
flutter run
```

Run on specific device:

```powershell
flutter devices
flutter run -d <deviceId>
```

Run web (Chrome):

```powershell
flutter run -d chrome
```

Debugging tips:

- Use Flutter DevTools for widget inspection and performance profiling
- Use `flutter logs` to tail logs from connected devices

---

## Building for Release

### Android (AAB / APK)

```powershell
# Release APK
flutter build apk --release

# Build AAB (recommended for Play Store)
flutter build appbundle --release
```

Remember to configure `android/key.properties` and a keystore for signing.

### iOS

```powershell
flutter build ios --release
```

Open the generated Xcode workspace, set signing, and upload via Xcode or Transporter.

### Web

```powershell
flutter build web --release
```

---

## Configuration & Environment

The app requires configuration for backend endpoints and environment flags. Two common approaches:

1. Pass values via `--dart-define`:

```powershell
flutter run --dart-define=API_BASE_URL="https://your-backend-url" --dart-define=ENV=development
```

2. Use `flutter_dotenv` with a `.env` file (not committed to source control):

```env
API_BASE_URL=https://your-backend-url
SENTRY_DSN=
FEATURE_FLAG_NEW_UI=true
```

Security note: Do not store sensitive server-side keys in client builds.

Recommended dart-defines:

- `API_BASE_URL` - Base URL for the EdTech backend
- `SENTRY_DSN` - Crash reporting (optional)
- `ENV` - `development` or `production`

---

## Authentication Flow

Typical authentication flow with Appwrite or token-based backend:

1. User signs in with email/password or OAuth.
2. App receives an access token (and refresh token if supported).
3. Token stored securely (e.g., `shared_preferences` for non-sensitive tokens, secure storage for refresh tokens).
4. Token included in Authorization header for API requests:

```
Authorization: Bearer <access_token>
```

5. On token expiry, app uses refresh token or redirects user to login.

Implementation notes:

- Check `lib/data/auth_repository.dart` (or similar) for authentication logic.
- Use `flutter_secure_storage` to persist sensitive tokens.

---

## Data & API Integration

- API clients live in `lib/data/` and reference `API_BASE_URL`.
- Models are typically in `lib/data/models` and mapped to JSON from the backend responses.
- Common endpoints used:
  - `GET /courses`
  - `GET /courses/{id}`
  - `POST /enroll`
  - `GET /lessons?courseId=`
  - `POST /quiz-attempts`

Respect API response structure documented in the backend `README.md`.

---

## Assets & Theming

- Fonts and images live in `assets/` and are declared in `pubspec.yaml`.
- Theme is usually defined in `lib/app/core/theme/`.
- Prefer using `Theme.of(context)` and `TextTheme` for consistent styling.

---

## Localization

If localization is implemented, it will typically use `flutter_localizations` and generated ARB files in `lib/l10n` or similar. To add a new language:

1. Add new ARB file (e.g., `intl_en.arb`, `intl_es.arb`)
2. Run code generation (if using `flutter intl` or `flutter_localizations` generator)

---

## Testing

### Unit & Widget tests

Run tests:

```powershell
flutter test
```

Run a specific test file:

```powershell
flutter test test/my_widget_test.dart
```

### Integration tests

If the project contains integration tests, they can be run using `flutter drive` or the newer integration_test package.

---

## CI / Release Guidance

- Use GitHub Actions to run `flutter analyze`, `flutter test`, and `flutter build`.
- Cache Flutter SDK and pub packages for faster runs.
- Sign builds using secure secrets for keystore / Apple credentials.

Example CI steps:

1. Checkout repo
2. Set up Flutter
3. Run `flutter pub get`
4. Run `flutter analyze` and `flutter test`
5. Build: `flutter build apk --release` or `flutter build web --release`
6. Upload artifacts

---

## Troubleshooting

- `flutter pub get` fails: try `flutter clean` then `flutter pub get`.
- Device not found: `flutter devices` to verify available devices, ensure emulator is running.
- iOS signing issues: open Xcode and fix signing for `Runner` target.
- Network errors: verify `API_BASE_URL` and that backend is reachable from the device/emulator.

---

## Feedback & Contributing

If you'd like to contribute improvements or report bugs:

1. Open an issue describing the problem or feature
2. Fork the repo and create a branch
3. Submit a pull request with tests and documentation updates

For UX feedback, provide screenshots, device details, and steps to reproduce.

---

## License

This project follows the main repository license. Add `LICENSE` here if needed for the user app specifically.

---

If you want, I can now:

- Add an example `.env.example` and show how to load it in the app
- Create a GitHub Actions workflow for CI
- Add sample screenshots and a basic visual style guide

Which one should I add next?