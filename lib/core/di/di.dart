import 'package:get_it/get_it.dart';

import 'package:task/core/database/database_helper.dart';
import 'package:task/features/tasks/data/datasources/sync_queue_datasource.dart';
import 'package:task/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:task/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:task/features/tasks/domain/repositories/task_repository.dart';
import 'package:task/features/tasks/domain/services/priority_service.dart';
import 'package:task/features/tasks/domain/services/completion_learning_service.dart';
import 'package:task/features/tasks/sync/sync_manager.dart';

import '../../features/tasks/presentation/blocs/task_bloc.dart';
import '../theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  sl.registerLazySingleton(() => DatabaseHelper.instance);

  sl.registerLazySingleton(() => TaskLocalDataSource(sl()));
  sl.registerLazySingleton(() => SyncQueueDataSource(sl()));

  sl.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(localDataSource: sl(), syncQueueDataSource: sl()));

  final learning = CompletionLearningService();
  await learning.init();
  sl.registerSingleton(learning);
  sl.registerLazySingleton(() => PriorityService());

  sl.registerFactory(() => TaskBloc(sl()));
  sl.registerLazySingleton(() => ThemeCubit());

  sl.registerLazySingleton(() {
    final manager = SyncManager(sl());
    manager.init();
    return manager;
  });
}
