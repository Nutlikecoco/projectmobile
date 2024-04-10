class Rickandmorty {
  final String? name;
  final String? type;
  final String? gender;
  final String? origin;
  final String? image;
  bool isFavorite; // เพิ่มฟิลด์ isFavorite

  Rickandmorty({
    required this.name,
    required this.type,
    required this.gender,
    required this.origin,
    required this.image,
    this.isFavorite = false, // กำหนดค่าเริ่มต้นให้ isFavorite เป็น false
  });

  factory Rickandmorty.fromJson(Map<String, dynamic> json) {
    return Rickandmorty(
      name: json['name'],
      type: json['type'],
      gender: json['gender'],
      origin: json['origin'],
      image: json['image'],
      isFavorite: false, // กำหนดค่าเริ่มต้นให้ isFavorite เป็น false
    );
  }
}
