import 'package:plant_whisperer/entities/plant_entity.dart';
import 'package:plant_whisperer/models/plant.dart';

abstract class PlantRepository {
  Future<String> addPlantEntity(PlantEntity entity);
  Future<PlantEntity> getPlant(String plantUUID);
  Future<List<PlantEntity>> getPlants();
}
