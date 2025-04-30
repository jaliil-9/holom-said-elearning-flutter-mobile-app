import 'base_profile.dart';

class UserModel implements BaseProfile {
  @override
  final String id;
  @override
  final String firstname;
  @override
  final String lastname;
  @override
  final String email;
  @override
  final String profilePicture;
  final String? phoneNumber;
  final DateTime? birthDate;
  final String? maritalStatus;

  UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    this.profilePicture = '',
    this.phoneNumber,
    this.birthDate,
    this.maritalStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'profilepicture': profilePicture,
      'phonenumber': phoneNumber,
      'birthdate': birthDate?.toIso8601String(),
      'maritalstatus': maritalStatus,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilepicture'] ?? '',
      phoneNumber: json['phonenumber'],
      birthDate:
          json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
      maritalStatus: json['maritalstatus'],
    );
  }
}
