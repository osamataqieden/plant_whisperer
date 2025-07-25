import 'package:plant_whisperer/data/database_helper.dart';
import 'package:plant_whisperer/data/plant_achievements_repository.dart';
import 'package:plant_whisperer/models/plant_achievements.dart';
import 'package:sqflite/sqflite.dart';

class PlantAchievementsRepositoryImpl implements PlantAchievementsRepository {
  final DatabaseHelper _databaseHelper;

  PlantAchievementsRepositoryImpl({required DatabaseHelper databaseHelper})
      : _databaseHelper = databaseHelper;

  @override
  Future<void> addPlantAchievement(PlantAchievement plantAchievement) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'plant_achievements',
      plantAchievement.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deletePlantAchievement(String id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'plant_achievements',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Stream<List<PlantAchievement>> getPlantAchievements(String plantId) async* {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'plant_achievements',
      where: 'plantId = ?',
      whereArgs: [plantId],
    );

    if (maps.isNotEmpty) {
      yield maps.map((map) => PlantAchievement.fromMap(map)).toList();
    } else {
      yield [];
    }
  }

  @override
  Future<void> updatePlantAchievement(PlantAchievement plantAchievement) async {
    final db = await _databaseHelper.database;
    await db.update(
      'plant_achievements',
      plantAchievement.toMap(),
      where: 'id = ?',
      whereArgs: [plantAchievement.id],
    );
  }
}
