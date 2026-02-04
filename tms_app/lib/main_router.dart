import 'package:flutter/material.dart';
import 'package:tms_app/core/models/user_model.dart';
// Importa tus pantallas
import 'package:tms_app/modules/admin/admin_dashboard_screen.dart';
import 'package:tms_app/modules/client/request_cargo_screen.dart';
import 'package:tms_app/modules/dispatcher/dispatcher_dashboard_screen.dart';
import 'package:tms_app/modules/driver/driver_home_screen.dart';

class MainRouter extends StatelessWidget {
  final UserProfile user;
  final UserRole activeRole;

  const MainRouter({Key? key, required this.user, required this.activeRole}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pasamos 'user' a cada pantalla para que puedan dibujar el Drawer
    switch (activeRole) {
      case UserRole.ADMIN:
        return AdminDashboardScreen(user: user);
      case UserRole.CLIENTE:
        return RequestCargoScreen(user: user);
      case UserRole.DESPACHADOR:
        return DispatcherDashboardScreen(user: user);
      case UserRole.OPERADOR:
        return DriverHomeScreen(user: user);
      default:
        return Scaffold(
          body: Center(child: Text("Rol ${activeRole.name} no implementado")),
        );
    }
  }
}