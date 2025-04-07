import 'package:sqflite/sqflite.dart';
import 'grade.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._();
  static Database? _database;

  DatabaseService._();

  factory DatabaseService() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Initialize the database with the given schema
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    print('Database path: $dbPath'); // Add print statement to check database path
    return await openDatabase(
      '$dbPath/grades.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE grades (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            studentName TEXT NOT NULL,
            fatherName TEXT NOT NULL,
            progName TEXT NOT NULL,
            shift TEXT NOT NULL,
            rollno TEXT NOT NULL,
            courseCode TEXT NOT NULL,
            courseTitle TEXT NOT NULL,
            creditHours REAL NOT NULL,
            obtainedMarks REAL NOT NULL,
            mySemester TEXT NOT NULL,
            considerStatus TEXT NOT NULL
          )
        ''');
        print("Database created with table grades.");
      },
    );
  }

  // Insert grade into the database
  Future<void> insertGrade(Grade grade) async {
    final db = await database;
    await db.insert(
      'grades',
      grade.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Replace if a conflict occurs
    );
    print("Inserted grade: ${grade.studentName}, ${grade.courseTitle}"); // Print statement to check insertion
  }

  // Get all grades from the database
  Future<List<Grade>> getGrades() async {
    final db = await database;
    final maps = await db.query('grades');
    print("Fetched grades count: ${maps.length}"); // Log the number of grades fetched
    return maps.map((map) {
      return Grade(
        id: map['id'] as int,
        studentName: map['studentName'] as String,
        fatherName: map['fatherName'] as String,
        progName: map['progName'] as String,
        shift: map['shift'] as String,
        rollno: map['rollno'] as String,
        courseCode: map['courseCode'] as String,
        courseTitle: map['courseTitle'] as String,
        creditHours: (map['creditHours'] as num).toDouble(),
        obtainedMarks: (map['obtainedMarks'] as num).toDouble(),
        mySemester: map['mySemester'] as String,
        considerStatus: map['considerStatus'] as String,
      );
    }).toList();
  }

  // Delete a specific grade by ID
  Future<void> deleteGrade(int id) async {
    final db = await database;
    await db.delete('grades', where: 'id = ?', whereArgs: [id]);
  }

  // Delete all grades from the database
  Future<void> deleteAllGrades() async {
    final db = await database;
    await db.delete('grades');
  }
}
