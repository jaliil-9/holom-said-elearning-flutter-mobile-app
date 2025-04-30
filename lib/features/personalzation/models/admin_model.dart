import 'base_profile.dart';

class AdminModel implements BaseProfile {
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

  AdminModel(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.email,
      this.profilePicture = ''});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'profilepicture': profilePicture,
    };
  }

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilepicture'] ?? '',
    );
  }
}
