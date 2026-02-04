import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/models/user_model.dart';
import '../../shared/widgets/app_drawer.dart';

class DispatcherDashboardScreen extends StatefulWidget {
  final UserProfile user;
  const DispatcherDashboardScreen({super.key, required this.user});

  @override
  State<DispatcherDashboardScreen> createState() => _DispatcherDashboardScreenState();
}

class _DispatcherDashboardScreenState extends State<DispatcherDashboardScreen> {
  // ... (Tu método getCargasDisponibles se mantiene igual)
  Future<List<dynamic>> getCargasDisponibles() async {
    final url = Uri.parse('http://localhost:3000/api/cargas/disponibles');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bolsa de Cargas"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => setState(() {})),
        ],
      ),
      drawer: AppDrawer(user: widget.user), // Drawer agregado
      body: FutureBuilder<List<dynamic>>(
        future: getCargasDisponibles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          final cargas = snapshot.data ?? [];
          if (cargas.isEmpty) return const Center(child: Text("No hay cargas aprobadas por el momento."));

          return ListView.builder(
            itemCount: cargas.length,
            itemBuilder: (context, index) {
              final carga = cargas[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.local_shipping, color: Colors.blue),
                  title: Text("${carga['origen']} ➔ ${carga['destino']}"),
                  subtitle: Text("Peso: ${carga['peso']}T - Tipo: ${carga['tipoCarga']}"),
                  trailing: ElevatedButton(
                    onPressed: () {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Funcionalidad de Asignar en desarrollo")));
                    },
                    child: const Text("Tomar Carga"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}