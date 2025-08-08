# TapInc

> **Explore corporate bonds. View issuer details. Analyze financials.**

[![Flutter](https://img.shields.io/badge/Framework-Flutter-blue?logo=flutter)](#) [![Dart](https://img.shields.io/badge/Language-Dart-0175C2?logo=dart)](#) [![License](https://img.shields.io/badge/License-MIT-lightgrey)](#)

---

A production-grade **Flutter** application to explore corporate bonds, view issuer details, and analyze issuer financials. The app is built for performance, clean architecture, and an outstanding mobile experience.

<p align="center">
  <img alt="TapInc screenshot" src=".github/screenshot-placeholder.png" style="max-width:420px; width:100%; border-radius:12px; box-shadow:0 8px 30px rgba(0,0,0,0.12)">
</p>

## 📥 Quick download — APK

**Download the latest release APK:**

* [TapInc v1.0 (APK) — Google Drive]([https://drive.google.com/file/d/1HfPr4XaAMWZYSaYXG3_gjD985YssxXmq/view?usp=drive_link](https://drive.google.com/file/d/11Q5OUrMKvYqtKeEFzw8BvlDpPTx1ueop/view?usp=sharing))

> ⚠️ Install at your own risk: enable `Install unknown apps` for your device if needed.

---

## Table of Contents

* [Overview](#overview)
* [Highlights](#highlights)
* [Features](#features)
* [Architecture](#architecture)
* [Directory Layout](#directory-layout)
* [Tech Stack](#tech-stack)
* [Environment & Configuration](#environment--configuration)
* [Getting Started](#getting-started)
* [Run, Build, and Analyze](#run-build-and-analyze)
* [Data & Networking](#data--networking)
* [UI & UX](#ui--ux)
* [State Management](#state-management)
* [Performance Optimizations](#performance-optimizations)
* [Troubleshooting](#troubleshooting)
* [Contributing](#contributing)
* [License](#license)

---

## Overview

TapInc helps analysts and investors quickly browse corporate bonds, read issuer-level details, and inspect financial trends (Revenue / EBITDA) with interactive charts. The codebase follows clean architecture practices to keep UI, domain, and data concerns separated and testable.

## ✨ Highlights

* Polished, responsive UI for phones and tablets.
* Instant local search with highlighted matches (no extra network while typing).
* Interactive charts with tooltips, gridlines, and adaptive Y‑axis scaling.
* Robust networking (retry, caching) and clear error handling.

## Features

* Compact, information-rich bond cards (ISIN, issuer, rating, logo).
* Bond detail page with tabs: **Bond Info**, **ISIN Analysis**, **Pros & Cons**.
* Custom EBITDA & Revenue charts using `fl_chart` and smart scaling.
* Soft in-memory caching and graceful fallbacks for offline-like UX.
* BLoC-based state management with clear events & states.

## Architecture

The project uses a layered architecture:

* `core/` — DI, networking, constants, error models.
* `features/` — feature folders (each with `domain/`, `data/`, `presentation/`).
* `presentation/` — widgets, screens, and BLoCs live here.

This keeps the app maintainable and easy to test.

## Directory Layout

```
lib/
  core/
    constants/
    di/
    error/
    network/
  features/
    bonds_list/
      data/
      domain/
      presentation/
    bond_detail/
      data/
      domain/
      presentation/
  main.dart
```

## Tech Stack

* **Flutter** (stable)
* **Dart**
* `flutter_bloc` for state management
* `dio` for HTTP with logging & retry
* `fl_chart` for charts
* `injectable` + `get_it` for DI

## Environment & Configuration

Sensitive URLs are injected at build time using `--dart-define`. Do not commit secrets.

Create a file `assets/.env` with:

```
BASE_URL=
BONDS_LIST_URL=
BOND_DETAIL_URL=
```

Run app (development):

```bash
flutter run --dart-define-from-file=assets/.env
```

> Tip: If you'd like `flutter run` to run without extra flags, create a short script (`run.sh` / `run.bat`) in your repo that calls the above command.

## Getting Started

1. Install Flutter & Dart (see official docs).
2. Run: `flutter pub get`.
3. Set env vars in `assets/.env`.
4. Launch on device/emulator.

## Run, Build, and Analyze

* Debug run:

```bash
flutter run --dart-define-from-file=assets/.env
```

* Release APK:

```bash
flutter build apk --dart-define-from-file=assets/.env
```

* Static analysis:

```bash
flutter analyze
```

## Data & Networking

`DioClient` is configured with:

* Connection & receive timeouts
* Debug logging only in `kDebugMode`
* Retry once on timeouts
* In-memory GET cache (TTL: 60s)

Repositories implement soft caching with TTL and `forceRefresh` flags for predictable UX.

## UI & UX

* **Bonds Explorer** screen: compact cards, fast local search, and clear CTA.
* **Bond Detail**: logo header, ISIN badge, and three tabs for structured content.
* Charts are responsive with adaptive axes and interactive tooltips.

## State Management

* BLoC per feature (list & detail).
* Events: `Load`, `Refresh`, `Search`.
* States: `Initial`, `Loading`, `Loaded`, `Error`.

## Performance Optimizations

* Network-level caching & retry.
* UI-level selective rebuilds and precomputed layouts.
* Optional prefetch strategy available as an enhancement.

## Troubleshooting

* **AGP/Gradle warnings**: update Android Gradle Plugin per Flutter guidance.
* **No data**: ensure `--dart-define` env variables are passed.
* **APK install issues**: enable `Install unknown apps` on device.

## Contributing

* Keep changes modular and well-tested.
* Prefer composition over deep widget trees.
* Respect the domain/data/presentation separation.

---

## Changelog

* **v1.0** — Initial production-ready release.

## License

This project is released under the **MIT License**.

---

> Need the README exported as a `README.md` file or committed to a branch? I can prepare the file for download or create a PR-ready patch. Want me to add release notes, screenshots, or a CI badge next?
