enum UserRole { ADMIN, DESPACHADOR, OPERADOR, CLIENTE }

class UserProfile {
  final String email;
  final UserRole role;
  final String token;

  UserProfile({required this.email, required this.role, required this.token});

  factory UserProfile.fromJson(Map<String, dynamic> json, String token) {
    return UserProfile(
      email: json['email'],
      role: UserRole.values.firstWhere((e) => e.toString().split('.').last == json['role']),
      token: token,
    );
  }
}