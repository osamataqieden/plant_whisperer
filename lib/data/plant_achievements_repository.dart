import 'package:plant_whisperer/models/plant_achievements.dart';

abstract class PlantAchievementsRepository {
  Future<void> addPlantAchievement(PlantAchievement plantAchievement);
  Future<void> deletePlantAchievement(String id);
  Future<void> updatePlantAchievement(PlantAchievement plantAchievement);
  Stream<List<PlantAchievement>> getPlantAchievements(String plantId);
}
