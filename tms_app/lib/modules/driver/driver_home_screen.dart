import 'package:flutter/material.dart';
import '../../core/models/user_model.dart';
import '../../shared/widgets/app_drawer.dart';

class DriverHomeScreen extends StatelessWidget {
  final UserProfile user;

  // Constructor requerido para recibir el usuario y que funcione el Router
  const DriverHomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Viajes Asignados")),
      drawer: AppDrawer(user: user), // Menú lateral conectado
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Tarjeta estática para la demo (simulando un viaje asignado)
          Card(
            elevation: 4,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.local_shipping, color: Colors.white),
              ),
              title: const Text("Morelia ➔ Lázaro Cárdenas", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 5),
                  Text("Carga: Electrónicos - 5 Ton"),
                  Text("Estado: En Ruta", style: TextStyle(color: Colors.green)),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Aquí iría al detalle del mapa en el futuro
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Abriendo navegación GPS...")),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Un mensaje si no hay más viajes
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("No tienes más viajes pendientes hoy.", style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}