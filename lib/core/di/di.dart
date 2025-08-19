import 'package:get_it/get_it.dart';

/// Service locator singleton
final sl = GetIt.instance;

/// Sets up the dependencies for the application.
///
/// This should be called **once** at application startup before the widget
/// tree is built. New registrations belong in the appropriate section to keep
/// things tidy.
Future<void> setupLocator() async {
  // 🔧 Core & Utils ---------------------------------------------------------
  // TODO: Register Logger, NetworkInfo, etc.

  // 📦 External Packages ----------------------------------------------------
  // Nothing yet – add database, preferences, and HTTP client here later.
}
