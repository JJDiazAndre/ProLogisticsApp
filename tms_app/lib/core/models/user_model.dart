enum UserRole { ADMIN, DESPACHADOR, OPERADOR, CLIENTE }

class UserProfile {
  final int id;
  final String email;
  final List<UserRole> roles;
  final String token;

  UserProfile({required this.id, required this.email, required this.roles, required this.token});

  factory UserProfile.fromJson(Map<String, dynamic> json, String token) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      // Convertimos el array de strings que viene del JSON a Lista de Enums
      roles: (json['roles'] as List)
          .map((r) => UserRole.values.firstWhere((e) => e.name == r))
          .toList(),
      token: token,
    );
  }
}