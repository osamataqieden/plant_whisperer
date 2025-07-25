class UserAchievement {
  final String id;
  final String userId;
  final String achievement;
  final DateTime date;

  UserAchievement({
    required this.id,
    required this.userId,
    required this.achievement,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'achievement': achievement,
      'date': date.toIso8601String(),
    };
  }

  factory UserAchievement.fromMap(Map<String, dynamic> map) {
    return UserAchievement(
      id: map['id'],
      userId: map['userId'],
      achievement: map['achievement'],
      date: DateTime.parse(map['date']),
    );
  }
}
