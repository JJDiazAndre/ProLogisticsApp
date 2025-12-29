import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/services/api_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Lista ficticia para la UI inicial, luego la traeremos de la API
  List<Map<String, dynamic>> empresas = [
    {"id": 1, "nombre": "Transportes Rápidos S.A.", "status": "Pendiente"},
    {"id": 2, "nombre": "Logística Global", "status": "Verificado"},
  ];

  Future<List<dynamic>> fetchCargas() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/cargas'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  // 1. Agrega este método dentro de la clase _AdminDashboardScreenState
  Future<List<dynamic>> getCargas() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/cargas'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar datos');
    }
  }

  // 2. Modifica el 'body' de tu Scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // ... (Tu NavigationRail anterior se queda igual)
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: getCargas(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No hay cargas registradas"));
                }

                final listaCargas = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- NUEVO BLOQUE CON TÍTULO Y BOTÓN ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Cargas Pendientes de Asignación",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh, color: Colors.blue),
                            tooltip: "Actualizar datos",
                            onPressed: () {
                              setState(() {
                                // Al llamar a setState vacío, Flutter vuelve a ejecutar 
                                // el FutureBuilder y pide los datos a la API de nuevo.
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Origen')),
                              DataColumn(label: Text('Destino')),
                              DataColumn(label: Text('Peso (T)')),
                              DataColumn(label: Text('Estado')),
                            ],
                            rows: listaCargas.map((item) => DataRow(cells: [
                              DataCell(Text(item['id'].toString())),
                              DataCell(Text(item['origen'])),
                              DataCell(Text(item['destino'])),
                              DataCell(Text(item['peso'].toString())),
                              DataCell(Chip(label: Text(item['status']))),
                            ])).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}