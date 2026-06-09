class VolunteerLocal {
  final int? id;
  final String name;
  final String description;
  final String image;
  final String location;
  final String registrationLink;

  VolunteerLocal({
    this.id,
    required this.name,
    required this.description,
    this.image = '',
    required this.location,
    this.registrationLink = '',
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'image': image,
      'location': location,
      'registration_link': registrationLink,
    };
  }

  factory VolunteerLocal.fromMap(Map<String, dynamic> map) {
    return VolunteerLocal(
      id: map['id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      location: map['location'] ?? '',
      registrationLink: map['registration_link'] ?? '',
    );
  }

  VolunteerLocal copyWith({
    int? id,
    String? name,
    String? description,
    String? image,
    String? location,
    String? registrationLink,
  }) {
    return VolunteerLocal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      location: location ?? this.location,
      registrationLink: registrationLink ?? this.registrationLink,
    );
  }
}
