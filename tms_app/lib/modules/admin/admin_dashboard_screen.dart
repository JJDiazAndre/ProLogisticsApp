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

  Future<void> cambiarEstadoCarga(int id, String nuevoEstado) async {
    final url = Uri.parse('http://localhost:3000/api/cargas/$id/status');
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': nuevoEstado}),
      );

      if (response.statusCode == 200) {
        setState(() {}); // Refresca la tabla automáticamente
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Carga $id actualizada a $nuevoEstado')),
        );
      }
    } catch (e) {
      print("Error al actualizar: $e");
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
                          child: 
                          // Dentro del DataTable en el FutureBuilder:
                          DataTable(
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Origen')),
                              DataColumn(label: Text('Destino')),
                              DataColumn(label: Text('Estado')),
                              DataColumn(label: Text('Acciones')), // 5 columnas en total
                            ],
                            rows: listaCargas.map((item) => DataRow(cells: [
                              DataCell(Text(item['id'].toString())),
                              DataCell(Text(item['origen'] ?? '')),
                              DataCell(Text(item['destino'] ?? '')),
                              DataCell(Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: item['status'] == 'PENDIENTE' ? Colors.orange[100] : Colors.green[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(item['status'] ?? 'PENDIENTE'),
                              )),
                              DataCell(Row( // Quinta celda con acciones para la demo
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green),
                                    onPressed: () => cambiarEstadoCarga(item['id'], 'APROBADA'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () => cambiarEstadoCarga(item['id'], 'CANCELADA'),
                                  ),
                                ],
                              )),
                            ])).toList(),
                          )
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