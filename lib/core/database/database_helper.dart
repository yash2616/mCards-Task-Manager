import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _dbName = 'task_manager.db';
  static const _dbVersion = 2;

  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE tasks(
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  category TEXT,
  due_date INTEGER,
  priority INTEGER,
  completed INTEGER,
  updated_at INTEGER
)''');

    await db.execute('''
CREATE TABLE sync_queue(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  operation TEXT NOT NULL,
  task_id TEXT NOT NULL,
  payload TEXT,
  timestamp INTEGER
)''');

    // Indices for faster queries
    await db.execute('CREATE INDEX idx_tasks_due_date ON tasks(due_date);');
    await db.execute('CREATE INDEX idx_tasks_priority ON tasks(priority);');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('CREATE INDEX IF NOT EXISTS idx_tasks_due_date ON tasks(due_date);');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_tasks_priority ON tasks(priority);');
    }
  }
}
