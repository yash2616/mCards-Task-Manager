import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class AppBlocObserver extends BlocObserver {
  final GlobalKey<ScaffoldMessengerState> messengerKey;
  AppBlocObserver(this.messengerKey);

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(error.toString())),
    );
    super.onError(bloc, error, stackTrace);
  }
}
