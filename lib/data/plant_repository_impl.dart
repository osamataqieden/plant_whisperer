import 'package:plant_whisperer/data/database_helper.dart';
import 'package:plant_whisperer/data/plant_repository.dart';
import 'package:plant_whisperer/models/plant.dart';
import 'package:sqflite/sqflite.dart';

class PlantRepositoryImpl implements PlantRepository {
  final DatabaseHelper _databaseHelper;

  PlantRepositoryImpl({required DatabaseHelper databaseHelper})
    : _databaseHelper = databaseHelper;

  @override
  Future<void> addPlant(Plant plant) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'plants',
      plant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deletePlant(String id) async {
    final db = await _databaseHelper.database;
    await db.delete('plants', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Stream<Plant> getPlant(String id) async* {
    final db = await _databaseHelper.database;
    final maps = await db.query('plants', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      yield Plant.fromMap(maps.first);
    }
  }

  @override
  Stream<List<Plant>> getPlants() async* {
    final db = await _databaseHelper.database;
    final maps = await db.query('plants');

    if (maps.isNotEmpty) {
      yield maps.map((map) => Plant.fromMap(map)).toList();
    } else {
      yield [];
    }
  }

  @override
  Future<void> updatePlant(Plant plant) async {
    final db = await _databaseHelper.database;
    await db.update(
      'plants',
      plant.toMap(),
      where: 'id = ?',
      whereArgs: [plant.id],
    );
  }
}
