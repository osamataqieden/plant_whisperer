class PlantEntity {
  final String species;
  final String commonName;
  final String creativeName;
  final String personality;
  final int wateringSchedule; // in days
  final int healthStatus; // scale of 1 to 10
  final List<String> careTips; // formatted as a list of tips
  final List<String> achievements; // formatted as a list of achievements
  final String? imagePath; // optional image path for the plant
  final String? imageBase64; // optional base64 encoded image data
  PlantEntity(
    this.species,
    this.commonName,
    this.creativeName,
    this.personality,
    this.wateringSchedule,
    this.healthStatus,
    this.careTips,
    this.achievements,
    this.imagePath,
    this.imageBase64,
  );
}
