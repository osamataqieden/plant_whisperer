class PlantImage {
  final String id;
  final String plantId;
  final String imageUrl;

  PlantImage({
    required this.id,
    required this.plantId,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plantId': plantId,
      'imageUrl': imageUrl,
    };
  }

  factory PlantImage.fromMap(Map<String, dynamic> map) {
    return PlantImage(
      id: map['id'],
      plantId: map['plantId'],
      imageUrl: map['imageUrl'],
    );
  }
}
