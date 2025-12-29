import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  // Si pruebas en el emulador de Android, usa 10.0.2.2 en lugar de localhost
  final String baseUrl = "http://localhost:3000/api"; 

  Future<UserProfile?> login(String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'role': role, // Enviamos rol para que Flutter cambie de vista al probar
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserProfile.fromJson(data['user'], data['access_token']);
      }
      return null;
    } catch (e) {
      print("Error de conexión: $e");
      return null;
    }
  }
}