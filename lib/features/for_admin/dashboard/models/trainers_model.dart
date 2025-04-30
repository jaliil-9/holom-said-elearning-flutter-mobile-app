class Trainer {
  final String? id;
  final String firstName;
  final String lastName;
  final String? description;
  final String specialty;
  final String? profilePictureUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get fullName => '$firstName $lastName';

  Trainer({
    this.id,
    required this.firstName,
    required this.lastName,
    this.description,
    required this.specialty,
    this.profilePictureUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Trainer copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? description,
    String? specialty,
    String? profilePictureUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Trainer(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      description: description ?? this.description,
      specialty: specialty ?? this.specialty,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Trainer.fromJson(Map<String, dynamic> json) {
    return Trainer(
      id: json['id'] as String?,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      description: json['description'] as String?,
      specialty: json['specialty'] as String,
      profilePictureUrl: json['profile_picture_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'first_name': firstName,
      'last_name': lastName,
      if (description != null) 'description': description,
      'specialty': specialty,
      if (profilePictureUrl != null) 'profile_picture_url': profilePictureUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Trainer &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.description == description &&
        other.specialty == specialty &&
        other.profilePictureUrl == profilePictureUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        description.hashCode ^
        specialty.hashCode ^
        profilePictureUrl.hashCode;
  }
}
