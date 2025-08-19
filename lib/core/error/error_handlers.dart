import 'dart:async';

import 'package:flutter/material.dart';

void setupGlobalErrorHandling(GlobalKey<ScaffoldMessengerState> messengerKey) {
  FlutterError.onError = (details) {
    FlutterError.dumpErrorToConsole(details);
    messengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(details.exceptionAsString())),
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(error.toString())),
    );
    return true;
  };

  runZonedGuarded<Future<void>>(() async {}, (error, stack) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(error.toString())),
    );
  });
}
