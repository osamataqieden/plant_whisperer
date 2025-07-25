import 'package:plant_whisperer/models/plant_images.dart';

abstract class PlantImagesRepository {
  Future<void> addPlantImage(PlantImage plantImage);
  Future<void> deletePlantImage(String id);
  Stream<List<PlantImage>> getPlantImages(String plantId);
}
