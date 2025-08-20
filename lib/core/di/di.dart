import 'package:get_it/get_it.dart';

import 'package:task/core/database/database_helper.dart';
import 'package:task/features/tasks/data/datasources/sync_queue_datasource.dart';
import 'package:task/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:task/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:task/features/tasks/domain/repositories/task_repository.dart';
import 'package:task/features/tasks/domain/services/priority_service.dart';
import 'package:task/features/tasks/sync/sync_manager.dart';

import '../../features/tasks/presentation/blocs/task_bloc.dart';
import '../theme/theme_cubit.dart';

/// Service locator singleton
final sl = GetIt.instance;

/// Sets up the dependencies for the application.
///
/// This should be called **once** at application startup before the widget
/// tree is built. New registrations belong in the appropriate section to keep
/// things tidy.
Future<void> setupLocator() async {
  // 🔧 Core & External -------------------------------------------------------
  sl.registerLazySingleton(() => DatabaseHelper.instance);

  // 🗄️ Datasources ----------------------------------------------------------
  sl.registerLazySingleton(() => TaskLocalDataSource(sl()));
  sl.registerLazySingleton(() => SyncQueueDataSource(sl()));

  // 📦 Repositories ---------------------------------------------------------
  sl.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(localDataSource: sl(), syncQueueDataSource: sl()));

  // 🎯 Services -------------------------------------------------------------
  sl.registerLazySingleton(() => PriorityService());

  // 🧠 Blocs/Cubits ---------------------------------------------------------
  sl.registerFactory(() => TaskBloc(sl()));
  sl.registerLazySingleton(() => ThemeCubit());

  // 🔄 Sync Manager ---------------------------------------------------------
  sl.registerLazySingleton(() {
    final manager = SyncManager(sl());
    manager.init();
    return manager;
  });
}
