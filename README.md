# 🎟️ Evendly

> Discover events. Save moments.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev) [![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com) [![CI](https://github.com/your-github-username/evendly-flutter-app/actions/workflows/flutter_ci.yml/badge.svg)](../../actions/workflows/flutter_ci.yml)

Evendly is a Flutter event discovery and digital ticketing application that helps people explore events, find nearby experiences, save favourites, and manage QR-based digital tickets.

## ✨ Overview

Built as a portfolio-ready mobile application, Evendly combines realtime Firebase data with location-aware discovery in a focused, responsive Flutter interface.

## 🚀 Features

- Firebase email authentication, onboarding, and profile setup
- Realtime event discovery with category, price, scope, availability, and nearby filters
- Search, favourites, event details, maps, and location support
- Booking orders, e-tickets, QR tickets, reviews, and cancellations
- Notifications and light/dark themes

## 📱 Screenshots

Screenshots will be added from real devices or emulators. See [the screenshot checklist](docs/screenshots/README.md) for the recommended set.

## 🧰 Tech Stack

- Flutter and Dart
- Firebase Authentication, Cloud Firestore, and Firebase Storage
- Google Maps Flutter, Geolocator, and Geocoding
- `qr_flutter`, `intl`, and Shared Preferences

## 🏗️ Architecture

The project is organised by feature. Pages and reusable widgets call small repositories/services, which integrate with Firebase and platform APIs. The home screen is split into a navigation shell, feed, filtering service, filter sheet, and focused UI widgets.

See [architecture notes](docs/ARCHITECTURE.md).

## 📂 Project Structure

```text
lib/
  core/             Theme, services, and shared widgets
  features/         Product features organised by concern
    home/            Home shell, feed widgets, filter logic, and models
    events/          Event models, repository, and details
    orders/          Order data/domain/presentation flow
  routes/            Application routing
firebase/            Versioned Firestore and Storage rule templates
test/                Fast, Firebase-independent tests
```

## 🔥 Firebase Integration

Firebase configuration is retained so existing registrations continue to work. The visible product and Dart package use Evendly; the native identifiers remain `com.goeventapp.dev` for Android and `com.example.goeventApp` for iOS because those values are tied to the supplied Firebase app registrations.

Rule templates live in `firebase/firestore.rules` and `firebase/storage.rules`. Review them against your production data model before deployment, then deploy deliberately with the Firebase CLI.

## 📍 Location & Maps

Location is optional. It supports the nearby filter and event map experiences; users can continue browsing when permission is unavailable.

## 🎟️ Digital Ticket Flow

Discover an event → view its details → place an order → open the digital ticket → present its QR code at the venue.

## 🧪 Testing

The test suite covers deterministic filtering logic and does not require a live Firebase project.

```bash
flutter test
```

## 🔄 Continuous Integration

The GitHub Actions workflow runs `flutter pub get`, `flutter analyze`, and `flutter test` on pushes to `main` and pull requests targeting `main`.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK compatible with the repository SDK constraint
- A Firebase project configured for the supplied native identifiers
- Google Maps keys and platform permissions where required

### Installation

```bash
git clone https://github.com/your-github-username/evendly-flutter-app.git
cd evendly-flutter-app
flutter pub get
```

### Firebase Setup

The repository includes Firebase configuration for its existing project. For a personal Firebase project, register Android and iOS apps first, then regenerate `lib/firebase_options.dart` and platform configuration using FlutterFire CLI. Do not change package or bundle identifiers without matching Firebase registrations.

### Run

```bash
flutter run
```

## 🗺️ Roadmap

- Add verified device screenshots
- Add Firebase Emulator integration coverage for order and profile flows
- Replace legacy raster logo artwork with approved Evendly assets when available

## 🤝 Contributing

Issues and focused pull requests are welcome. Please run formatting, analysis, and tests before opening a pull request.

## 📄 License

No licence has been selected yet. Add a licence file before distributing or accepting external contributions.

## Repository metadata

Recommended repository name: `evendly-flutter-app` (or simply `evendly`).

Suggested description: “A modern Flutter event discovery and digital ticketing app powered by Firebase, location services, and QR-based tickets.”

Suggested topics: `flutter`, `dart`, `firebase`, `firestore`, `firebase-auth`, `google-maps`, `event-discovery`, `ticketing`, `qr-code`, `mobile-app`, `portfolio`.
