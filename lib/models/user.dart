class User {
  final int? id;
  final String? email;
  final String? name;
  final String? phone;
  final String? profileImage;
  final String? location;
  final double? temperature;
  final DateTime? createdAt;

  User({
    this.id,
    this.email,
    this.name,
    this.phone,
    this.profileImage,
    this.location,
    this.temperature,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      profileImage: json['profileImage'] ?? json['profile_image'],
      location: json['location'],
      temperature: json['temperature'] != null
          ? (json['temperature'] is String
              ? double.tryParse(json['temperature'])
              : json['temperature']?.toDouble())
          : null,
      createdAt: (json['createdAt'] ?? json['created_at']) != null
          ? DateTime.parse(json['createdAt'] ?? json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'profile_image': profileImage,
      'location': location,
      'temperature': temperature,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
