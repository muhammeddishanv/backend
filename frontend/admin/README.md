# Admin (Flutter)

Comprehensive documentation for the `admin` Flutter application. This repository folder contains the Flutter admin app used to manage the EdTech platform (courses, lessons, quizzes, users, analytics, etc.). This README explains the project structure, how to run, build, test, configure, and extend the app.

## Table of Contents

- Overview
- Prerequisites
- Project structure
- Installation
- Running the app (debug & release)
- Building for platforms (Android / iOS / web / desktop)
- Configuration & environment
- Assets & localization
- Testing
- CI / Deployment notes
- Common tasks & tips
- Troubleshooting
- Contributing
- License

## Overview

The `admin` app is a Flutter-based application that serves as the administrative interface for the EdTech platform. Features typically include:

- Course and lesson management
- Quiz and question management
- User management and roles
- Enrollment and transactions view
- Analytics / performance dashboards
- Badge and rank management
- Notification center

The app is intended to be used by platform administrators and instructors. It communicates with the backend (Appwrite Function) via REST HTTP endpoints. The backend URL and authentication are provided via runtime configuration.

## Prerequisites

- Flutter SDK (>= 3.0) installed and available on PATH. See: https://docs.flutter.dev/get-started/install
- Dart SDK (bundled with Flutter)
- An editor: VS Code or Android Studio recommended
- Android SDK / Xcode (if building mobile)
- Chrome (for web) or desktop toolchains if building for those platforms

Verify Flutter installation:

```powershell
flutter --version
flutter doctor
```

## Project structure

Top-level layout (abbreviated):

```
admin/
├── android/            # Android project files
├── ios/                # iOS project files
├── lib/                # Main Dart source
│   ├── main.dart       # App entrypoint
│   ├── app/            # App architecture (core, data, modules, routes)
│   ├── core/           # Error handling, theme, utils
│   ├── data/           # API clients, models, repositories
│   ├── modules/        # Feature modules (courses, quizzes, users...)
│   └── global_widgets/ # Reusable UI components
├── assets/             # Fonts, icons, images
├── test/               # Widget & unit tests
├── pubspec.yaml        # Flutter package manifest
├── analysis_options.yaml
└── README.md           # This file
```

Notes:

- `lib/app` usually contains app-level wiring: dependency injection, route definitions, theme, and error handlers.
- `lib/data` contains code that talks to your backend (API client wrappers for the Appwrite endpoints) and data models.
- `lib/modules` groups features into self-contained modules (e.g., `admin_create_course`, `admin_dashboard`).

## Installation

1. Open a terminal in `frontend/admin`.
2. Get packages:

```powershell
flutter pub get
```

3. (Optional) Format code and analyze:

```powershell
flutter format .
flutter analyze
```

## Running the app

Run in debug mode (default device or emulator):

```powershell
flutter run
```

Run on a specific device (list devices first):

```powershell
flutter devices
flutter run -d <deviceId>
```

Run web (Chrome):

```powershell
flutter run -d chrome
```

Run in profile or release mode:

```powershell
flutter run --profile
flutter run --release
```

## Building

### Android (APK / AAB)

```powershell
# Build APK (debug)
flutter build apk --debug

# Build release APK
flutter build apk --release

# Build Android App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### iOS

macOS with Xcode required:

```powershell
# Build for device (opens Xcode workspace)
flutter build ios --release
```

### Web

```powershell
flutter build web --release
```

### Desktop

```powershell
# Windows
flutter build windows

# macOS
flutter build macos

# Linux
flutter build linux
```

## Configuration & Environment

This app expects the backend base URL and some runtime keys. The project uses typical Flutter patterns for configuration (environment files, flavors, or `.env` via packages). Common approaches:

- Use `--dart-define` when running/building:

```powershell
flutter run --dart-define=API_BASE_URL="https://your-backend-url" --dart-define=ENV=development
```

- Or use a package like `flutter_dotenv` to load `.env` during development.

Recommended keys:

- `API_BASE_URL` - Backend base URL (Appwrite function URL)
- `API_KEY` or `APPWRITE_API_KEY` - If backend requires an API key (keep secret out of client builds)
- `SENTRY_DSN` - Optional for crash reporting

Security note: Never embed production API secrets into mobile clients. Use server-side tokens or user-auth flows.

## Assets & Localization

- Fonts and images live under `assets/` and are declared in `pubspec.yaml`.
- To add fonts or images: place them in the assets folder and update `pubspec.yaml`:

```yaml
flutter:
	assets:
		- assets/images/
	fonts:
		- family: Inter
			fonts:
				- asset: assets/fonts/Inter-Regular.ttf
```

- Localization: If the app supports multiple locales, check `lib/app/core/locale` or similar and use `flutter_localizations`.

## Testing

### Unit & Widget tests

Run all tests:

```powershell
flutter test
```

Run a single test file:

```powershell
flutter test test/widget_test.dart
```

### Integration tests

If integration tests are present, run with:

```powershell
flutter drive --target=test_driver/app.dart
```

## CI / Deployment Notes

- Use GitHub Actions or GitLab CI. A typical pipeline:
	1. Install Flutter
	2. Run `flutter pub get`
	3. Run `flutter analyze` and `flutter test`
	4. Build artifacts (`flutter build apk`, `flutter build web`)
	5. Upload artifacts to release or distribution channels

- For Android Play Store: produce AAB, sign with keystore
- For iOS App Store: build archive in Xcode and upload via Transporter or App Store Connect

## Common Tasks & Tips

- Add a new module: place UI and business logic inside `lib/modules/<feature>` and register routes in `lib/app/routes`.
- API client: centralize HTTP code in `lib/data/api_client.dart`. Keep models in `lib/data/models`.
- State management: this project may use Provider, Riverpod, Bloc, or GetX—follow the existing pattern in `lib/app/core`.

## Troubleshooting

- `flutter pub get` fails: run `flutter clean` and retry.
- Missing SDKs: run `flutter doctor` and install required dependencies.
- iOS build fails on macOS: open `ios/Runner.xcworkspace` in Xcode and resolve signing issues.
- Android signing: ensure `key.properties` and `keystore` are properly configured.

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/my-feature`
3. Implement tests and run them
4. Submit a pull request with a description of changes

Follow the style rules (formatter / analysis options) before submitting.

## License

Project license information is inherited from the main repository. If you need a license for the admin app, add a `LICENSE` file here.

---

If you want, I can also:

- add example `.env` and `.env.example` for local development
- add a small `CONTRIBUTING.md` template
- add CI workflow example for GitHub Actions

Tell me which of these you'd like next and I will add it.
