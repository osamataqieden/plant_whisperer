import 'package:plant_whisperer/data/database_helper.dart';
import 'package:plant_whisperer/data/user_achievements_repository.dart';
import 'package:plant_whisperer/models/user_achievements.dart';

class UserAchievementsRepositoryImpl implements UserAchievementsRepository {
  final DatabaseHelper _databaseHelper;

  UserAchievementsRepositoryImpl({required DatabaseHelper databaseHelper})
      : _databaseHelper = databaseHelper;

  @override
  Stream<List<UserAchievement>> getUserAchievements(String userId) async* {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'user_achievements',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      yield maps.map((map) => UserAchievement.fromMap(map)).toList();
    } else {
      yield [];
    }
  }
}
