class Person {
  final int id;
  final String name;
  final String image;
  final String status;
  final String species;
  final String location;

  Person({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.species,
    required this.location,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
      species: json['species'] ?? '',
      location: json['location'] is Map
          ? json['location']['name'] ?? ''
          : json['location']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'status': status,
      'species': species,
      'location': location,
    };
  }
}
