# Task Manager

A cross-platform Flutter application that demonstrates a Clean-Architecture approach to personal task tracking: offline-first data, smart priority scoring, and an adaptive UI.

---
## ✨ Features
• Create / edit / delete tasks with category & due-date.  
• Heuristic priority score with colour-coded indicator.  
• Search bar plus priority/date filters.  
• Offline-first SQLite storage with background sync when connectivity returns.

---
## 🧰 Tech Stack
• **Flutter 3.6** + **Dart 3.6**  
• **BLoC** for state management  
• **GetIt** Dependency Injection  
• **Sqflite** for local persistence  
• Unit & integration tests (≥ 70 % coverage)

---
## 🔑 Prerequisites
1. **Flutter SDK** >= 3.6 (stable channel)
2. **Dart** ships with Flutter (no extra install)
3. Xcode / Android Studio or any IDE with Flutter integration
4. An Android emulator or iOS simulator for integration tests

Verify your environment:
```bash
flutter doctor  # all check-marks should be green
```

---
## 🚀 Getting Started
```bash
# 1. Clone repository
$ git clone https://github.com/<your-org>/task.git
$ cd task

# 2. Install packages
$ flutter pub get

# 3. Run the app (pick a device or emulator)
$ flutter run   # or flutter run -d <deviceId>
```

---
## ✅ Running Tests & Coverage
```bash
# Unit tests with coverage
flutter test --coverage

# Integration tests (requires simulator/emulator)
flutter test integration_test

# View HTML coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # macOS – use xdg-open on Linux
```
Coverage should remain **≥ 70 %**; the CI pipeline fails otherwise.

---
## 🏗 Folder Structure (Clean Architecture)
```
lib/
  core/            # DI, theme, database, error handling
  features/
    tasks/
      application/ # SyncManager & other orchestrators
      data/        # datasources, models, repositories impl.
      domain/      # entities, enums, repositories contracts
      presentation/# blocs, pages, widgets
```
For deeper reasoning see [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

---
## 📄 License
MIT © 2025 Your Name
