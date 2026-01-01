import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import 'role_selector_screen.dart'; // Importación vital agregada

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  void _handleLogin() async {
    final api = ApiService();
    final user = await api.login(_emailController.text, _passController.text);

    if (user != null) {
      // Redirección lógica: si tiene varios roles va al selector, si no al router
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => RoleSelectorScreen(user: user)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Credenciales incorrectas")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("ProLogistics TMS", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: _passController, decoration: const InputDecoration(labelText: "Contraseña"), obscureText: true),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: const Text("Ingresar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}