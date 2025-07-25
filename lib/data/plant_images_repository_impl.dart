import 'package:plant_whisperer/data/database_helper.dart';
import 'package:plant_whisperer/data/plant_images_repository.dart';
import 'package:plant_whisperer/models/plant_images.dart';
import 'package:sqflite/sqflite.dart';

class PlantImagesRepositoryImpl implements PlantImagesRepository {
  final DatabaseHelper _databaseHelper;

  PlantImagesRepositoryImpl({required DatabaseHelper databaseHelper})
      : _databaseHelper = databaseHelper;

  @override
  Future<void> addPlantImage(PlantImage plantImage) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'plant_images',
      plantImage.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deletePlantImage(String id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'plant_images',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Stream<List<PlantImage>> getPlantImages(String plantId) async* {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'plant_images',
      where: 'plantId = ?',
      whereArgs: [plantId],
    );

    if (maps.isNotEmpty) {
      yield maps.map((map) => PlantImage.fromMap(map)).toList();
    } else {
      yield [];
    }
  }
}
