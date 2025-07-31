import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'plant_whisperer.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE plants(
        id TEXT PRIMARY KEY,
        name TEXT,
        species TEXT,
        purchaseDate TEXT,
        lastWatered TEXT,
        wateringFrequency INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE plant_achievements(
        id TEXT PRIMARY KEY,
        plantId TEXT,
        achievement TEXT,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE plant_images(
        id TEXT PRIMARY KEY,
        plantId TEXT,
        imageUrl TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE watering_history(
        id TEXT PRIMARY KEY,
        plantId TEXT,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE user_achievements(
        id TEXT PRIMARY KEY,
        userId TEXT,
        achievement TEXT,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE plant_tips(
      id TEXT PRIMARY KEY,
      plantId TEXT,
      tip TEXT)
    ''');
  }
}
