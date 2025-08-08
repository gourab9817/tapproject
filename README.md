# TapInc

> **Explore corporate bonds. View issuer details. Analyze financials.**

[![Flutter](https://img.shields.io/badge/Framework-Flutter-blue?logo=flutter)](#) [![Dart](https://img.shields.io/badge/Language-Dart-0175C2?logo=dart)](#) [![License](https://img.shields.io/badge/License-MIT-lightgrey)](#)

---

A production-grade **Flutter** application to explore corporate bonds, view issuer details, and analyze issuer financials. The app is built for performance, clean architecture, and an outstanding mobile experience.


## 📥 Quick download — APK

**Download the latest release APK:**

* [TapInc v1.0 (APK) — Google Drive](https://drive.google.com/file/d/11Q5OUrMKvYqtKeEFzw8BvlDpPTx1ueop/view?usp=sharing)

---

## 🎥 Demo Video

[![Watch the demo](https://img.youtube.com/vi/js2nLuFyz1k/0.jpg)](https://youtube.com/shorts/js2nLuFyz1k?feature=shared)

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
* Interactive charts with tooltips, gridlines, and adaptive Y-axis scaling.
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

