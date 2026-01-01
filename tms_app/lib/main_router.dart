import 'package:flutter/material.dart';
import 'package:tms_app/core/models/user_model.dart';
import 'package:tms_app/modules/admin/admin_dashboard_screen.dart';
import 'package:tms_app/modules/client/request_cargo_screen.dart';
import 'package:tms_app/modules/dispatcher/dispatcher_dashboard_screen.dart';
import 'package:tms_app/modules/driver/driver_home_screen.dart';

class MainRouter extends StatelessWidget {
  final UserProfile user;
  final UserRole activeRole; // El rol que el usuario eligió al entrar

  const MainRouter({Key? key, required this.user, required this.activeRole}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retornamos la vista según el rol ACTIVO
    switch (activeRole) {
      case UserRole.ADMIN:
        return AdminDashboardScreen();
      case UserRole.CLIENTE:
        return const RequestCargoScreen();
      case UserRole.DESPACHADOR:
        return const DispatcherDashboardScreen();
      case UserRole.OPERADOR:
        return DriverHomeScreen();
      default:
        return const Scaffold(body: Center(child: Text("Rol no definido")));
    }
  }
}