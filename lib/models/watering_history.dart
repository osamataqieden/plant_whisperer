class WateringHistory {
  final String id;
  final String plantId;
  final DateTime date;

  WateringHistory({
    required this.id,
    required this.plantId,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plantId': plantId,
      'date': date.toIso8601String(),
    };
  }

  factory WateringHistory.fromMap(Map<String, dynamic> map) {
    return WateringHistory(
      id: map['id'],
      plantId: map['plantId'],
      date: DateTime.parse(map['date']),
    );
  }
}
