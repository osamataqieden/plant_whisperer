import 'package:plant_whisperer/models/plant.dart';

abstract class PlantRepository {
  Future<void> addPlant(Plant plant);
  Future<void> deletePlant(String id);
  Future<void> updatePlant(Plant plant);
  Stream<List<Plant>> getPlants();
  Stream<Plant> getPlant(String id);
}
