import 'package:dio/dio.dart';
import '../models/user_model.dart';

class ApiService {
  // 1. Singleton: Asegura que solo exista una instancia de ApiService en toda la app
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;
  String? _authToken; // Guardamos el token en RAM para la demo

  // Constructor privado
  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: "http://localhost:3000/api", // Ajusta a 10.0.2.2 si usas emulador Android
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {'Content-Type': 'application/json'},
    ));

    // 2. Interceptor: Inyecta el token automáticamente en cada petición
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_authToken != null) {
          options.headers['Authorization'] = 'Bearer $_authToken';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // Aquí podríamos manejar errores globales como 401 Unauthorized
        print("❌ Error API: ${e.response?.statusCode} - ${e.message}");
        return handler.next(e);
      },
    ));
  }

  // --- MÉTODOS DE AUTENTICACIÓN ---

  Future<UserProfile?> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        final token = data['access_token'];
        
        // Guardamos el token en memoria
        _authToken = token;

        // Devolvemos el perfil
        return UserProfile.fromJson(data['user'], token);
      }
      return null;
    } catch (e) {
      print("Error en Login: $e");
      return null;
    }
  }

  void logout() {
    _authToken = null;
  }

  // --- MÉTODOS DE CARGAS (LOGÍSTICA) ---

  Future<List<dynamic>> getCargas() async {
    try {
      final response = await _dio.get('/cargas');
      return response.data;
    } catch (e) {
      print("Error getCargas: $e");
      return [];
    }
  }

  Future<List<dynamic>> getCargasDisponibles() async {
    try {
      final response = await _dio.get('/cargas/disponibles');
      return response.data;
    } catch (e) {
      return [];
    }
  }

  Future<bool> crearCarga(Map<String, dynamic> cargaData) async {
    try {
      await _dio.post('/cargas', data: cargaData);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> actualizarEstadoCarga(int id, String nuevoEstado) async {
    try {
      await _dio.patch('/cargas/$id/status', data: {'status': nuevoEstado});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> asignarCarga(int cargaId, int empresaId) async {
    // Pendiente de implementar en backend, dejamos la estructura lista
    return false; 
  }
}