import 'package:note_app_2/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init();

  NoteDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const sql = '''
    CREATE TABLE $tableNotes(
      ${NoteFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${NoteFields.isImportant} BOOLEAN NOT NULL,
      ${NoteFields.number} INTEGER NOT NULL,
      ${NoteFields.title} INTEGER NOT NULL,
      ${NoteFields.description} INTEGER NOT NULL,
      ${NoteFields.time} TEXT NOT NULL
    )
    ''';
    await db.execute(sql);
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<List<Note>> getAllNotes() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(tableNotes);
    return results.map((json) => Note.fromJson(json)).toList();
  }
}