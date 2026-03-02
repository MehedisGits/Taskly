<div align="center">

# Taskly

**A clean, full-featured task management app built with Flutter and GetX**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-%2302569B.svg?style=flat&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=flat&logo=dart&logoColor=white)](https://dart.dev)
[![GetX](https://img.shields.io/badge/GetX-State%20Management-purple?style=flat)](https://pub.dev/packages/get)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Linux-lightgrey?style=flat)](https://flutter.dev/multi-platform)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat)](LICENSE)

</div>

---

## Overview

Taskly is a cross-platform task management application designed to help users stay organized and productive. Built with Flutter and powered by a REST API backend, Taskly handles the full task lifecycle — from creation to completion — with a clean, responsive UI and real-time data synchronization.

---

## Features

### Authentication
- Email & password login and registration
- JWT token-based authentication with secure storage
- OTP verification for account confirmation
- Forgot password with email recovery flow
- Session persistence via SharedPreferences
- Auto-login on app launch with token validation

### Dashboard
- Task count summary cards — Total, Completed, In Progress, Cancelled
- Real-time task badge indicator
- Shimmer loading effect during data fetch
- Offline-first: loads cached data instantly, syncs fresh data in background
- Internet connectivity detection via `connectivity_plus`

### Task Management
- Create, read, update, and delete tasks
- Task status workflow: New → In Progress → Completed / Cancelled
- Task categories with bottom navigation filtering
- Swipe actions for quick edit and delete
- Bottom sheet form for task creation and editing with validation

### UX & Design
- Dark mode with preference persistence
- Responsive layout using `responsiveSize` utility
- Custom app bar with theme-aware colors
- Profile screen with user data fetched from API
- Smooth screen transitions (e.g., `Transition.downToUp`)

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| Language | Dart |
| State Management | GetX (Obx, controllers, dependency injection) |
| HTTP Client | Dio |
| Local Storage | SharedPreferences |
| UI Effects | shimmer |
| OTP Input | flutter_otp_text_field |
| Connectivity | connectivity_plus |
| Platforms | Android, iOS, Linux |

---

## Architecture

Taskly follows a clean layered architecture using GetX:

```
lib/
├── app/
│   ├── data/
│   │   ├── models/          # User, Task data models
│   │   ├── services/        # ApiService, AuthService, TaskStorageService
│   │   └── providers/       # ApiClient (Dio configuration)
│   ├── modules/
│   │   ├── auth/            # Login, Signup, OTP, Forgot Password
│   │   ├── dashboard/       # Dashboard screen + DashboardController
│   │   ├── tasks/           # Task list, Task form, Task card
│   │   └── profile/         # Profile screen + UserController
│   └── routes/              # AppPages, AppRoutes
└── main.dart
```

---

## Getting Started

### Prerequisites
- Flutter SDK 3.x
- Dart SDK
- A running backend API (see `ApiService` for endpoint configuration)

### Run locally

```bash
git clone https://github.com/MehedisGits/Taskly.git
cd Taskly
flutter pub get
flutter run
```

### Build for release

```bash
# Android APK
flutter build apk --release

# Linux desktop
flutter build linux --release
```

---

## Branches

| Branch | Description |
|---|---|
| `main` | Stable release — REST API integration, full auth flow, task CRUD |
| `Taskly-Advanced` | Active development — enhanced features, UI improvements |

---

## Roadmap

- [ ] Push notifications for task deadlines
- [ ] Team collaboration and task assignment
- [ ] Calendar view integration
- [ ] Cloud sync with Firebase or Supabase
- [ ] Widget support for Android home screen

---

## Author

**Rakibul Islam Mehedi**
Flutter Developer | Bangladesh

[![GitHub](https://img.shields.io/badge/GitHub-MehedisGits-181717?style=flat&logo=github)](https://github.com/MehedisGits)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-rakibulmehedi-0077B5?style=flat&logo=linkedin)](https://linkedin.com/in/rakibulmehedi)

---

<div align="center">
  <sub>Built with Flutter · Powered by GetX · MIT License</sub>
</div>
