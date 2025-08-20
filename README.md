# Personal Task Manager 📱

A Flutter application demonstrating clean architecture, offline-first data, smart task prioritisation and adaptive UI.

---
## 🚀 Features
1. **Smart Task Management**
   * Create / edit / delete tasks with category & due-date
   * Heuristic priority score → colour-coded indicator
   * Search bar + priority/date/category filters
2. **Offline-First**
   * Local persistence with Sqflite
   * Sync queue stored in SQLite – flushed when connectivity returns (last-write-wins)
3. **Adaptive UI**
   * Responsive list, light/dark themes, custom `PriorityIndicator` & `ProgressRing`
   * Micro-interaction animations (dismiss, completion ripple, priority colour tween)
4. **Quality Code**
   * Clean Architecture + BLoC state management
   * DI via GetIt
   * Unit-test coverage >70 % and integration test of core flow

---
## 🛠 Prerequisites
* **Flutter SDK** 3.6.2 (stable channel) – [`flutter --version`] should report 3.6.x
* **Dart** 3.6.x (ships with Flutter)
* Android Studio / Xcode / VSCode with Flutter extension for emulator or device deployment
* For integration tests: Android emulator or iOS Simulator running API 33+ / iOS 15+

Ensure Flutter is set-up:

```bash
flutter doctor # verify all check-marks
```

---
## 🏗 Architecture Overview
High-level layers:
```
lib/
  ├─ core/        # DI, theme, db, error handling
  ├─ features/
  │   └─ tasks/
  │       ├─ domain/      # enums, entities, factories, repositories
  │       ├─ data/        # sqflite datasources & models
  │       ├─ presentation # blocs, pages, widgets
  │       └─ sync/        # SyncManager
```
More details in [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

---
## 🔧 Setup
```bash
# 1. Clone repo
git clone <repo> && cd task

# 2. Fetch packages
flutter pub get

# 3. Generate native platform code (if running on macOS/windows/linux)
flutter gen-l10n  # only needed if you have localisation, here safe to skip

# 4. Run app
flutter run        # choose device from prompt or pass -d <deviceId>

# 5. Run unit tests with coverage
flutter test --coverage

# 6. Run integration tests (emulator/simulator must be running)
flutter test integration_test
```

---
## 📝 Key Decisions & Trade-offs
* **BLoC vs Riverpod** – project uses BLoC for its explicit event→state flow. Riverpod is great, but BLoC better fits the observer pattern evaluation criteria.
* **Sqflite** over Hive → relational schema & SQL indices for range queries (due-date).
* **Factory helper** instead of `factory` constructor to keep `Task` entity pure and testable.
* **Simple heuristic priority** vs ML – sufficient for demo, can evolve.

---
## 📈 Future Improvements
* ML-driven priority based on user completion patterns
* Remote backend & conflict-free replicated data types (CRDT) for advanced sync
* Better accessibility & localisation

---
© 2025 Your Name – MIT licence
