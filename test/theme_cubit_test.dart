import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:task/core/theme/theme_cubit.dart';

void main() {
  // Ensures Flutter bindings (and shared_prefs mocks) are initialised.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeCubit', () {
    test('loads saved theme mode on init', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'theme_mode': ThemeMode.dark.index,
      });

      // Act
      final cubit = ThemeCubit();

      // Wait for the emit coming from _load()
      await cubit.stream.firstWhere((m) => m == ThemeMode.dark);

      // Assert
      expect(cubit.state, ThemeMode.dark);

      await cubit.close();
    });

    test('toggle cycles between light and dark and persists value', () async {
      // Arrange – start with light mode saved.
      SharedPreferences.setMockInitialValues({
        'theme_mode': ThemeMode.light.index,
      });
      final cubit = ThemeCubit();

      // Wait for the initial load to finish (the first emission after construction).
      await cubit.stream.first;

      // Act – toggle once ⇒ expect dark.
      await cubit.toggle();
      expect(cubit.state, ThemeMode.dark);
      var prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('theme_mode'), ThemeMode.dark.index);

      // Act – toggle again ⇒ expect light.
      await cubit.toggle();
      expect(cubit.state, ThemeMode.light);
      prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('theme_mode'), ThemeMode.light.index);

      await cubit.close();
    });
  });
}
