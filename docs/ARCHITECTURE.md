# Architecture & Patterns

## Layered Clean Architecture
```
Presentation  <- BLoC / Cubit
Domain        <- Entities • Use-cases • Repositories (abstract)
Data          <- Datasources • Models • Repository impl.
Infrastructure<- Core (DB, DI, Theme, Error)
```
Dependencies point inwards only.

## State Management
* **TaskBloc** orchestrates CRUD & sync events
* **ThemeCubit** toggles theme with persistence

## Data Flow (Happy Path)
1. `TaskListPage` dispatches `AddTaskEvent`
2. `TaskBloc` calls `TaskRepository.addTask`
3. Repository → `TaskLocalDataSource.insertTask`
4. If offline, `SyncQueueDataSource.enqueue`
5. `SyncManager` flushes queue when online again

## Patterns Used
| Pattern   | File(s) | Purpose |
|-----------|---------|---------|
| Repository | `task_repository.dart` + impl | decouple data source |
| Factory    | `TaskFactory` | encapsulate creation & scoring |
| Observer   | `AppBlocObserver` | global error observation |
| Service    | `PriorityService` | pure domain algorithm |

## Error Handling
* FlutterError.onError, Zone & PlatformDispatcher → Snackbar via `ScaffoldMessenger`
* Bloc errors intercepted by `AppBlocObserver`

## Testing Strategy
* Unit tests cover PriorityService, repositories, SyncManager (mock queue), blocs.
* Integration test covers create→complete flow.
* Mocktail used for mocks.

---
Diagram (simplified):
```mermaid
graph TD;
UI-->Bloc;
Bloc-->Repository;
Repository-->LocalDB;
Repository-->SyncQueue;
SyncQueue-->|flush|RemoteBackend(("Cloud"));
```
