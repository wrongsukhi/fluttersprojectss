import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;
  static const String tableName = 'grades';
  static const String dbName = 'grades.db';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            studentname TEXT,
            fathername TEXT,
            progname TEXT,
            shift TEXT,
            rollno TEXT,
            coursecode TEXT,
            coursetitle TEXT,
            credithours TEXT,
            obtainedmarks TEXT,
            mysemester TEXT,
            consider_status TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveGrades(List<dynamic> grades) async {
    final db = await database;
    await db.delete(tableName); // Clear existing data
    for (var grade in grades) {
      await db.insert(tableName, {
        'studentname': grade['studentname'],
        'fathername': grade['fathername'],
        'progname': grade['progname'],
        'shift': grade['shift'],
        'rollno': grade['rollno'],
        'coursecode': grade['coursecode'],
        'coursetitle': grade['coursetitle'],
        'credithours': grade['credithours'],
        'obtainedmarks': grade['obtainedmarks'],
        'mysemester': grade['mysemester'],
        'consider_status': grade['consider_status'],
      });
    }
  }

  Future<void> addGrade(Map<String, String> grade) async {
    final db = await database;
    await db.insert(tableName, grade);
  }

  Future<List<Map<String, dynamic>>> getGrades() async {
    final db = await database;
    return await db.query(tableName);
  }

  Future<void> deleteGrade(int id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> eraseAllData() async {
    final db = await database;
    await db.delete(tableName);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}