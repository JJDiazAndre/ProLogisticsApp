import 'package:dio/dio.dart';
import '../models/user_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;
  String? _authToken;

  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: "http://localhost:3000/api",
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_authToken != null) {
          options.headers['Authorization'] = 'Bearer $_authToken';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // Manejo global de errores según el código de estado
        String errorMessage = "Ocurrió un error inesperado";
        
        if (e.type == DioExceptionType.connectionTimeout) {
          errorMessage = "Error de conexión: Tiempo de espera agotado";
        } else if (e.response?.statusCode == 401) {
          errorMessage = "Sesión expirada o no autorizada";
          _authToken = null; // Limpiamos token
          // Aquí podrías disparar un evento para redirigir al Login
        } else if (e.response?.statusCode == 403) {
          errorMessage = "No tienes permisos para realizar esta acción";
        } else if (e.response?.statusCode == 500) {
          errorMessage = "Error interno del servidor. Intente más tarde";
        }

        print("🚨 API_ERROR [$errorMessage]: ${e.response?.data}");
        
        // Retornamos el error formateado para que la UI pueda leerlo si quiere
        return handler.next(e);
      },
    ));
  }

  // --- MÉTODOS ---

  Future<UserProfile?> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        _authToken = data['access_token'];
        return UserProfile.fromJson(data['user'], _authToken!);
      }
      return null;
    } catch (e) {
      return null; // El interceptor ya logueó el error
    }
  }

  Future<List<dynamic>> getCargas() async {
    try {
      final response = await _dio.get('/cargas');
      return response.data;
    } catch (e) {
      return []; 
    }
  }

  Future<bool> actualizarEstadoCarga(int id, String nuevoEstado) async {
    try {
      final response = await _dio.patch('/cargas/$id/status', data: {'status': nuevoEstado});
      return response.statusCode == 200;
    } catch (e) {
      return false;
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

  Future<List<dynamic>> getChoferes() async {
    try {
      // Pide usuarios con rol OPERADOR
      final response = await _dio.get('/usuarios?rol=OPERADOR');
      return response.data;
    } catch (e) {
      print("Error al obtener choferes: $e");
      return [];
    }
  }

  Future<bool> asignarChofer(int cargaId, int choferId) async {
    try {
      await _dio.patch('/cargas/$cargaId/asignar', data: {'choferId': choferId});
      return true;
    } catch (e) {
      return false;
    }
  }
}