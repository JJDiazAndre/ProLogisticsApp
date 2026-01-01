import 'package:flutter/material.dart';
import 'package:tms_app/core/models/user_model.dart';
import 'package:tms_app/main_router.dart';

class RoleSelectorScreen extends StatelessWidget {
  final UserProfile user;
  const RoleSelectorScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.account_tree_outlined, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text("Selecciona un perfil", 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Tu cuenta tiene múltiples roles asignados:"),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Column(
                  children: user.roles.map((role) => ListTile(
                    leading: const Icon(Icons.login),
                    title: Text(role.name),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MainRouter(user: user, activeRole: role),
                        ),
                      );
                    },
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}