import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  final String baseUrl = "http://localhost:3000/api"; 

  Future<UserProfile?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // data['user'] ahora contiene la lista 'roles'
        return UserProfile.fromJson(data['user'], data['access_token']);
      }
      return null;
    } catch (e) {
      print("Error de conexión: $e");
      return null;
    }
  }
}