import 'package:flutter/material.dart';
import '../../core/models/user_model.dart';
import '../../core/services/api_service.dart';
import '../../shared/widgets/app_drawer.dart';

class AdminDashboardScreen extends StatefulWidget {
  final UserProfile user;

  const AdminDashboardScreen({super.key, required this.user});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // El servicio ahora es un Singleton, lo llamamos directamente
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel de Administración"),
        elevation: 2,
      ),
      // Inyectamos el menú lateral que permite cambiar de rol o cerrar sesión
      drawer: AppDrawer(user: widget.user),
      body: FutureBuilder<List<dynamic>>(
        // Usamos el nuevo método centralizado en ApiService
        future: _apiService.getCargas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text("Error al conectar con el servidor: ${snapshot.error}"),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text("Reintentar"),
                  )
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay cargas registradas en el sistema."));
          }

          final listaCargas = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Gestión de Cargas",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.blue),
                      tooltip: "Actualizar lista",
                      onPressed: () => setState(() {}),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        width: double.infinity,
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                          columns: const [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Origen')),
                            DataColumn(label: Text('Destino')),
                            DataColumn(label: Text('Estado')),
                            DataColumn(label: Text('Acciones')),
                          ],
                          rows: listaCargas.map((item) {
                            return DataRow(cells: [
                              DataCell(Text(item['id'].toString())),
                              DataCell(Text(item['origen'] ?? 'N/A')),
                              DataCell(Text(item['destino'] ?? 'N/A')),
                              DataCell(_buildStatusChip(item['status'])),
                              DataCell(
                                Row(
                                  children: [
                                    if (item['status'] == 'PENDIENTE') ...[
                                      IconButton(
                                        icon: const Icon(Icons.check_circle, color: Colors.green),
                                        tooltip: "Aprobar",
                                        onPressed: () => _updateStatus(item['id'], 'APROBADA'),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.cancel, color: Colors.red),
                                        tooltip: "Rechazar",
                                        onPressed: () => _updateStatus(item['id'], 'CANCELADA'),
                                      ),
                                    ] else 
                                      const Text("-", style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget auxiliar para los estados
  Widget _buildStatusChip(String? status) {
    Color color = Colors.grey;
    if (status == 'PENDIENTE') color = Colors.orange;
    if (status == 'APROBADA') color = Colors.green;
    if (status == 'CANCELADA') color = Colors.red;
    if (status == 'ASIGNADA') color = Colors.blue;

    return Chip(
      label: Text(
        status ?? 'DESCONOCIDO',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
    );
  }

  // Método para actualizar estado usando el nuevo ApiService
  Future<void> _updateStatus(int id, String nuevoEstado) async {
    final success = await _apiService.actualizarEstadoCarga(id, nuevoEstado);
    if (success) {
      setState(() {}); // Refrescamos la UI
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Carga #$id actualizada a $nuevoEstado')),
        );
      }
    }
  }
}