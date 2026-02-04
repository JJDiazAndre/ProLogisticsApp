import 'package:flutter/material.dart';
import 'package:tms_app/core/models/user_model.dart';
import 'package:tms_app/modules/auth/login_screen.dart';
import 'package:tms_app/modules/auth/role_selector_screen.dart';

class AppDrawer extends StatelessWidget {
  final UserProfile user;
  
  const AppDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Tomamos la inicial del email para el avatar
    final initial = user.email.isNotEmpty ? user.email[0].toUpperCase() : '?';
    final accountName = user.email.split('@')[0];

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(accountName),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(initial, style: const TextStyle(fontSize: 24, color: Colors.blue)),
            ),
            decoration: const BoxDecoration(color: Colors.blue),
          ),
          
          // Solo mostramos "Cambiar Perfil" si el usuario tiene múltiples roles
          if (user.roles.length > 1) ...[
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text('Cambiar de Perfil'),
              onTap: () {
                // Navegamos al selector de roles
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => RoleSelectorScreen(user: user)),
                );
              },
            ),
            const Divider(),
          ],

          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
            onTap: () {
              // Navegamos al Login y borramos todo el historial de navegación
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}