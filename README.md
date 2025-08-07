# TapInc

A production-grade Flutter application to explore corporate bonds, view issuer details, and analyze financials. The app is optimized for performance, clean architecture, and responsive design.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Directory Layout](#directory-layout)
- [Tech Stack](#tech-stack)
- [Environment & Configuration](#environment--configuration)
- [Getting Started](#getting-started)
- [Run, Build, and Analyze](#run-build-and-analyze)
- [Data & Networking](#data--networking)
- [UI & UX](#ui--ux)
- [State Management](#state-management)
- [Performance Optimizations](#performance-optimizations)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Overview
The app provides:
- A bonds list with compact, responsive cards and instant client-side search.
- Bond detail screen with tabs (Bond Info, ISIN Analysis, Pros & Cons).
- Custom, responsive charts for EBITDA and Revenue with smart Y‑axis scaling.
- Clean state management with BLoC and a layered architecture (domain/data/presentation).

## Features
- Responsive UI for phones and tablets.
- Search-as-you-type with highlighted matches (no API calls while typing).
- Interactive charts (tooltips, grid, dynamic scaling).
- Issuer details (lead manager, registrar, etc.).
- Error handling with fallbacks and snackbars.

## Architecture
Clean, layered architecture:
- Core: DI, networking, constants, failures.
- Features: Each module has domain, data, and presentation layers.
- State: BLoC pattern with feature-specific blocs/events/states.

## Directory Layout
```
lib/
  core/
    constants/            # AppConstants, build-time configuration, timeouts
    di/                   # Dependency injection setup
    error/                # Failure models
    network/              # DioClient (retry, caching)
  features/
    bonds_list/
      data/               # Models, repositories (BondsRepositoryImpl)
      domain/             # Entities, repository contracts
      presentation/       # Screens, widgets, BLoC
    bond_detail/
      data/               # Models, repository (BondDetailRepositoryImpl)
      domain/             # Entities, contracts
      presentation/       # Screen + tabs, widgets, BLoC
  main.dart
```

## Tech Stack
- Flutter, Dart
- State management: flutter_bloc
- HTTP: Dio (logging in debug, retry-once on timeouts, in-memory GET cache)
- Charts: fl_chart + custom rendering
- DI: injectable/get_it

## Environment & Configuration
Sensitive URLs are injected at build time via `--dart-define` (do not hardcode or commit them).

Required keys:
- `BASE_URL`
- `BONDS_LIST_URL`
- `BOND_DETAIL_URL`

Create an env file (example path `assets/.env`):
```
BASE_URL=
BONDS_LIST_URL=
BOND_DETAIL_URL=
```
Run with a file:
```
flutter run --dart-define-from-file=assets/.env
```

Note: Do NOT list `.env` in `pubspec.yaml` (it is not a runtime asset).

## Getting Started
1. Install Flutter SDK and Dart.
2. Fetch packages: `flutter pub get`
3. Configure env (see above).
4. Run on a device or emulator (see below).

## Run, Build, and Analyze
- Run (debug):
```
flutter run --dart-define-from-file=assets/.env
```
- Build release APK:
```
flutter build apk --dart-define-from-file=assets/.env
```
- Static analysis:
```
flutter analyze
```

# Flutter and Dart Version Used 
```
Dart SDK version: 3.8.1
Flutter 3.32.8 • channel stable • https://github.com/flutter/flutter.git
Framework • revision edada7c56e (13 days ago) • 2025-07-25 14:08:03 +0000
Engine • revision ef0cd00091 (2 weeks ago) • 2025-07-24 12:23:50 -0700
Tools • Dart 3.8.1 • DevTools 2.45.1
```

## Data & Networking
- `DioClient`:
  - Configured timeouts.
  - Debug logging only in `kDebugMode`.
  - Retry-once for timeout errors (connection/receive/send).
  - Transparent in-memory GET cache with a default 60s TTL to accelerate repeated requests.
- Repositories:
  - `BondsRepositoryImpl.getBonds({forceRefresh=false})`: soft in-memory cache with TTL and fallback on failure.
  - `BondDetailRepositoryImpl.getBondDetail(isin, {forceRefresh=false})`: per‑ISIN soft cache with TTL and fallback.

## UI & UX
- Bonds List (`Bonds Explorer`):
  - Compact cards: brand logo, ISIN (last 4 digits emphasized), rating + company name, chevron.
  - Instant client-side search; highlights matched substrings.
  - “SUGGESTED RESULTS” or “SEARCH RESULTS” header based on context.
- Bond Detail:
  - Header with company logo/name, ISIN badge.
  - Tabs: Bond Info, ISIN Analysis, Pros & Cons.
  - Charts: EBITDA/Revenue line charts (fl_chart) with grid, tooltips, dynamic axis scaling, and responsive sizes.

## State Management
- BLoC per feature (list and detail).
- Events: load/refresh/search.
- States: initial/loading/loaded/error + derived UI state.
- List search is purely local (no network while typing).

## Performance Optimizations
- Transport: retry-once on timeouts, GET cache with TTL, debug-only logging.
- Repository: soft cache with TTL and error fallback.
- UI: precomputed/responsive layouts and selective rebuilds.
- Optional (easy to add): prefetch N details after list load for instant navigation.

## Troubleshooting
- AGP/Gradle warnings: upgrade Gradle/AGP as needed per Flutter tooling guidance.
- No data: verify env variables are passed correctly (see [Environment & Configuration](#environment--configuration)).
- Build errors on `.env`: ensure you’re using `--dart-define` flags; do not declare `.env` as an asset.

## Contributing
- Follow existing code style (readable, explicit types on public APIs, guard clauses, minimal nesting).
- Keep UI responsive; prefer composition over deep widget trees.
- Preserve architecture boundaries (domain/data/presentation) and BLoC state ownership.

---
This project is designed to be a clean, fast, and maintainable Flutter codebase for financial data exploration. If you need additional automation (prefetching, ETag/conditional requests, or CI scripts), open an issue/PR and we’ll extend it.
