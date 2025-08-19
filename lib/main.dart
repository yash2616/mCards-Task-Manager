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
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      title: 'Task Manager',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => sl<TaskBloc>()..add(const LoadTasks()),
        child: const TaskListPage(),
      ),
    );
  }
}
