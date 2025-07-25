import 'package:plant_whisperer/models/watering_history.dart';

abstract class WateringHistoryRepository {
  Future<void> addWateringHistory(WateringHistory wateringHistory);
  Stream<List<WateringHistory>> getWateringHistory(String plantId);
}
