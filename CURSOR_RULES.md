# Cursor Rules – Personal Task Manager

## 1. Guiding Principles
1. **Clean Architecture** – Strict separation of Presentation, Domain, Data, and Infrastructure layers.
2. **SOLID** – All code must adhere to the five SOLID principles. When in doubt, refactor.
3. **BLoC‐First State Management (flutter_bloc)** – All transient application state is handled by Cubit/Bloc classes provided via `BlocProvider`.
4. **Offline-First** – The app must gracefully degrade when offline and seamlessly sync when online.
5. **Quality over Quantity** – Prioritize readable, testable, and maintainable code.

## 2. Folder Structure
```
lib/
  ├─ core/            # Cross-cutting concerns (error, utils, DI, themes)
  ├─ features/
  │   └─ tasks/
  │       ├─ data/    # Data sources, models, SQLite DAOs, DTOs
  │       ├─ domain/  # Entities, repositories (abstract), use cases
  │       ├─ presentation/
  │       │   ├─ providers/  # Riverpod providers only
  │       │   ├─ blocs/      # Cubit/Bloc classes & states
  │       │   ├─ widgets/    # Pure UI components
  │       │   └─ pages/      # Screens & routing
  │       └─ sync/    # Sync queue & conflict resolution logic
  └─ main.dart        # AppRoot with DI bootstrap
```

## 3. Dependency Injection
• Use a lightweight service locator (`GetIt` or custom) declared in `core/di/di.dart`.<br/>
• Providers should read from the service locator **only** for external resources.
• Blocs receive dependencies via constructor injection during DI bootstrap; business logic must not access the service locator directly.

## 4. BLoC Rules
1. **Stateless Widgets First** – UI listens to Bloc/Cubit state via `BlocBuilder`, `BlocSelector`, or `BlocListener`; no mutable state inside widgets.
2. **Bloc Types** –
   • `Cubit` for straightforward mutate-only states (e.g., theme toggle).<br/>
   • `Bloc` for more complex logic with multiple events (e.g., tasks CRUD & sync).<br/>
3. Keep blocs focused; split responsibilities rather than creating monolithic "God" blocs.

## 5. Data Layer & Sync
• Local DB: SQLite tables via **sqflite** (`tasks`, `sync_queue`).<br/>
• All CRUD operations go through a `TaskRepository` abstraction.<br/>
• When offline: enqueue mutations in `sync_queue` with timestamp.<br/>
• Sync service flushes queue when network returns (last-write-wins).

## 6. Priority Calculation
• Expose `PriorityService.calculate(Task)` returning `PriorityLevel` ENUM.<br/>
• Factors: due date proximity, historical completion rate, user weighting.

## 7. UI & UX
• Adaptive layout via `LayoutBuilder`, `MediaQuery`.
• Theme: Light & Dark, stored in `shared_preferences`.
• Custom Widgets: `PriorityIndicator`, `ProgressRing`.
• Animations: Use `ImplicitlyAnimatedWidget` or `AnimationController` for micro-interactions.

## 8. Error Handling
• Global error handler (`FlutterError.onError`) logs and shows snackbar/dialog.
• Each async call wrapped in `Either<Result, Failure>` pattern.

## 9. Testing Standards
| Layer           | Coverage | Notes                               |
|-----------------|----------|-------------------------------------|
| Domain          | ≥ 90%    | Pure Dart unit tests                |
| Data            | ≥ 80%    | Mock DB & network                   |
| Presentation    | ≥ 60%    | Widget tests w/ `flutter_test`      |
| Integration     | ≥ 1 flow | e.g., create → offline edit → sync  |

• Use **Mockito** or **mocktail** for mocks.<br/>
• CI must fail if coverage < 70% overall.

## 10. Code Style & Commit Rules
• Follow `analysis_options.yaml` (pedantic_lints).<br/>
• One logical change per commit; conventional commits.

## 11. Packages Allowed
`flutter_bloc`, `bloc`, `equatable`, `sqflite`, `shared_preferences`, `dio`, `path_provider`.

## 12. Performance Targets
• Smooth scrolling with 1000+ tasks – use `ListView.builder` + `AutomaticKeepAliveClientMixin`.
• Debounced search (`300ms`).

## 13. Documentation
• Public APIs must have DartDoc comments.<br/>
• Keep README high-level; architecture explained with diagrams.

---
> Keep this file up-to-date as architecture evolves. Treat it as the single source of truth for project conventions.
