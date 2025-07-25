import 'package:plant_whisperer/models/user_achievements.dart';

abstract class UserAchievementsRepository {
  Stream<List<UserAchievement>> getUserAchievements(String userId);
}
