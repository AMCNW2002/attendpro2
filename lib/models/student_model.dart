class Student {
  final String id;
  final String name;
  final String city;

  Student({required this.id, required this.name, required this.city});

  factory Student.fromJson(Map<String, dynamic> json, String id) {
    return Student(
      id: id,
      name: json['name'] ?? '',
      city: json['city'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'city': city,
    };
  }
}
