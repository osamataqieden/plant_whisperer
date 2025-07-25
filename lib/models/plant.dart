class Plant {
  final String id;
  final String name;
  final String species;
  final DateTime purchaseDate;
  final DateTime lastWatered;
  final int wateringFrequency;

  Plant({
    required this.id,
    required this.name,
    required this.species,
    required this.purchaseDate,
    required this.lastWatered,
    required this.wateringFrequency,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'purchaseDate': purchaseDate.toIso8601String(),
      'lastWatered': lastWatered.toIso8601String(),
      'wateringFrequency': wateringFrequency,
    };
  }

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'],
      name: map['name'],
      species: map['species'],
      purchaseDate: DateTime.parse(map['purchaseDate']),
      lastWatered: DateTime.parse(map['lastWatered']),
      wateringFrequency: map['wateringFrequency'],
    );
  }
}
