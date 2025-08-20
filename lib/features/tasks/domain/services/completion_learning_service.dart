import 'package:shared_preferences/shared_preferences.dart';

class CompletionLearningService {
  static const _key = 'avg_late_days';

  double _avgLateDays = 0; // rolling average
  int _count = 0;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _avgLateDays = prefs.getDouble(_key) ?? 0;
    _count = prefs.getInt('$_key-count') ?? 0;
  }

  double get penaltyMultiplier {
    if (_avgLateDays <= 0) return 1.0;
    if (_avgLateDays < 1) return 1.1;
    if (_avgLateDays < 3) return 1.25;
    return 1.4; // chronically late, bump priority more
  }

  Future<void> recordCompletion({required DateTime? dueDate, required DateTime completedAt}) async {
    if (dueDate == null) return;
    final lateness = completedAt.difference(dueDate).inDays; // negative if early
    if (lateness <= 0) return; // ignore on-time or early completions

    _avgLateDays = ((_avgLateDays * _count) + lateness) / (_count + 1);
    _count++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_key, _avgLateDays);
    await prefs.setInt('$_key-count', _count);
  }
}
