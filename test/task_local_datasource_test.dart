import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:task/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:task/features/tasks/data/models/task_model.dart';
import 'package:task/features/tasks/domain/enums/category.dart';
import 'package:task/core/database/database_helper.dart';

void main() {
  sqfliteFfiInit();
  late Database db;
  late TaskLocalDataSource ds;

  setUp(() async {
    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    // create table schema
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
    // create minimal helper that returns this db
    final helper = _FakeHelper(db);
    ds = TaskLocalDataSource(helper);
  });

  tearDown(() async {
    await db.close();
  });

  test('insert and fetch', () async {
    final task = TaskModel(
      id: '1',
      title: 'Local Test',
      category: Category.others,
      updatedAt: DateTime(2025),
    );
    await ds.insertTask(task);
    final all = await ds.getAllTasks();
    expect(all.length, 1);
    expect(all.first.title, 'Local Test');
  });
}

class _FakeHelper implements DatabaseHelper {
  final Database _db;
  _FakeHelper(this._db);
  @override
  Future<Database> get database async => _db;
}
