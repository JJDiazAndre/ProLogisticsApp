import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tms_app/core/models/user_model.dart';
import 'package:tms_app/shared/widgets/app_drawer.dart';

class RequestCargoScreen extends StatefulWidget {
  final UserProfile user;
  const RequestCargoScreen({super.key, required this.user});

  @override
  State<RequestCargoScreen> createState() => _RequestCargoScreenState();
}

class _RequestCargoScreenState extends State<RequestCargoScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Campos del formulario
  String origin = '';
  String destination = '';
  double weight = 0.0;
  String cargoType = 'General';

  Future<void> _submitRequest() async {
    print("Intentando enviar formulario..."); // DIAGNÓSTICO 1
    
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print("Datos validados: $origin, $destination, $weight"); // DIAGNÓSTICO 2

      // IMPORTANTE: Asegúrate de que la URL incluya /api si pusiste el prefijo en NestJS
      final url = Uri.parse('http://localhost:3000/api/cargas'); 
      
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'origen': origin,
            'destino': destination,
            'peso': weight,
            'tipoCarga': cargoType,
            'cliente': {"id": 1} // NestJS espera un objeto o ID para la relación
          }),
        );

        print("Respuesta API: ${response.statusCode} - ${response.body}"); // DIAGNÓSTICO 3

        if (response.statusCode == 201 || response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Carga publicada con éxito!')),
          );
        }
      } catch (e) {
        print("Error fatal de conexión: $e");
      }
    } else {
      print("El formulario no es válido");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Solicitar Transporte de Carga")),
      drawer: AppDrawer(user: widget.user),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Punto de Origen (Dirección)', icon: Icon(Icons.location_on)),
                onSaved: (val) => origin = val ?? '',
                validator: (val) => val!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Punto de Destino', icon: Icon(Icons.flag)),
                onSaved: (val) => destination = val ?? '',
                validator: (val) => val!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Peso Estimado (Toneladas)', icon: Icon(Icons.monitor_weight)),
                keyboardType: TextInputType.number,
                onSaved: (val) => weight = double.tryParse(val ?? '0') ?? 0,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: cargoType,
                decoration: const InputDecoration(labelText: 'Tipo de Carga'),
                items: ['General', 'Contenedor', 'Maquinaria', 'Peligrosa'].map((String val) {
                  return DropdownMenuItem(value: val, child: Text(val));
                }).toList(),
                onChanged: (val) => setState(() => cargoType = val!),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                onPressed: _submitRequest, 
                child: const Text("Publicar Solicitud de Carga", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}