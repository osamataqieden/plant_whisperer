class PlantTips {
  final String plantUUID;
  final String tip;
  PlantTips({
    required this.plantUUID, required this.tip
  });

  Map<String, dynamic> toMap() {
    return {
      'tip': tip,
      'plantUUID': plantUUID
    };
  }
}