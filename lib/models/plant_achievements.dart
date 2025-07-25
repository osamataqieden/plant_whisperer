class PlantAchievement {
  final String id;
  final String plantId;
  final String achievement;
  final DateTime date;

  PlantAchievement({
    required this.id,
    required this.plantId,
    required this.achievement,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plantId': plantId,
      'achievement': achievement,
      'date': date.toIso8601String(),
    };
  }

  factory PlantAchievement.fromMap(Map<String, dynamic> map) {
    return PlantAchievement(
      id: map['id'],
      plantId: map['plantId'],
      achievement: map['achievement'],
      date: DateTime.parse(map['date']),
    );
  }
}
