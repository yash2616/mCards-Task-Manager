import 'package:flutter/material.dart';
import 'core/di/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/tasks/presentation/blocs/task_bloc.dart';
import 'features/tasks/presentation/pages/task_list_page.dart';
import 'core/error/app_bloc_observer.dart';
import 'core/error/error_handlers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  final messengerKey = GlobalKey<ScaffoldMessengerState>();
  setupGlobalErrorHandling(messengerKey);
  Bloc.observer = AppBlocObserver(messengerKey);

  runApp(MyApp(messengerKey: messengerKey));
}

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> messengerKey;
  const MyApp({super.key, required this.messengerKey});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<TaskBloc>()..add(const LoadTasks())),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: messengerKey,
        title: 'Task Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const TaskListPage(),
      ),
    );
  }
}
