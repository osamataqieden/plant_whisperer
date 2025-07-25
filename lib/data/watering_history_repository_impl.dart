import 'package:plant_whisperer/data/database_helper.dart';
import 'package:plant_whisperer/data/watering_history_repository.dart';
import 'package:plant_whisperer/models/watering_history.dart';
import 'package:sqflite/sqflite.dart';

class WateringHistoryRepositoryImpl implements WateringHistoryRepository {
  final DatabaseHelper _databaseHelper;

  WateringHistoryRepositoryImpl({required DatabaseHelper databaseHelper})
      : _databaseHelper = databaseHelper;

  @override
  Future<void> addWateringHistory(WateringHistory wateringHistory) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'watering_history',
      wateringHistory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Stream<List<WateringHistory>> getWateringHistory(String plantId) async* {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'watering_history',
      where: 'plantId = ?',
      whereArgs: [plantId],
    );

    if (maps.isNotEmpty) {
      yield maps.map((map) => WateringHistory.fromMap(map)).toList();
    } else {
      yield [];
    }
  }
}
