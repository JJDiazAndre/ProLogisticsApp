import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../main_router.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  String _selectedRole = 'CLIENTE'; // Para pruebas rápidas

  void _handleLogin() async {
    final api = ApiService();
    // El login ya no necesita el rol como parámetro, el servidor nos dirá cuáles tiene
    final user = await api.login(_emailController.text, _passController.text);

    if (user != null) {
      // Si solo tiene un rol, entra directo. Si tiene varios, va al selector.
      if (user.roles.length == 1) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => MainRouter(user: user, activeRole: user.roles[0])),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => RoleSelectorScreen(user: user)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Fallido")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Pro Logistics TMS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _passController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            DropdownButton<String>(
              value: _selectedRole,
              items: ['ADMIN', 'DESPACHADOR', 'OPERADOR', 'CLIENTE'].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (val) => setState(() => _selectedRole = val!),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _handleLogin, child: Text("Ingresar")),
          ],
        ),
      ),
    );
  }
}