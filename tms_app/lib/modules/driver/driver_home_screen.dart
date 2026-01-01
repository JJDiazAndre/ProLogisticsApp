import 'package:flutter/material.dart';

class DriverHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mis Viajes Asignados")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.navigation, color: Colors.blue),
              title: Text("Morelia -> Lázaro Cárdenas"),
              subtitle: Text("Estado: En ruta"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }
}