import 'package:flutter/material.dart';
import 'package:tms_app/core/models/user_model.dart';
import 'package:tms_app/modules/admin/admin_dashboard_screen.dart';
import 'package:tms_app/modules/client/request_cargo_screen.dart';

class MainRouter extends StatelessWidget {
  final UserProfile user;

  const MainRouter({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (user.role) {
      case UserRole.ADMIN:
        return AdminDashboardScreen();
      case UserRole.CLIENTE:
        return const RequestCargoScreen(); // El formulario que acabas de crear
      case UserRole.OPERADOR:
        return const Scaffold(body: Center(child: Text("Vista de Chofer (Móvil)")));
      case UserRole.DESPACHADOR:
        return const Scaffold(body: Center(child: Text("Vista de Empresa (Escritorio)")));
      default:
        return const Scaffold(body: Center(child: Text("Rol no reconocido")));
    }
  }
}