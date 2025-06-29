import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:agri_cria_app/envia_notificaciones.dart';

class CrearNotificacionScreen extends StatefulWidget {
  const CrearNotificacionScreen({super.key});

  @override
  State<CrearNotificacionScreen> createState() =>
      _CrearNotificacionScreenState();
}

class _CrearNotificacionScreenState extends State<CrearNotificacionScreen> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController commentController = TextEditingController();
  String selectedReminder = 'En 1 hora';

  final List<String> reminderOptions = [
    'En 5 segundos',
    'En 10 segundos',
    'En 1 hora',
    'En 2 horas',
    'En 3 horas',
    'En 1 día',
    'En 2 días',
    'En 3 días',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _guardarNotificacion() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final fecha = selectedDate.toIso8601String();
    final comentarios = commentController.text;
    final recordatorio = selectedReminder;

    final url = Uri.parse(
        'https://api-agri-cria-production.up.railway.app/api/guardaNotificaciones');
    //final url = Uri.parse('http://localhost:3000/api/guardaNotificaciones');

    final body = jsonEncode({
      'fecha': fecha,
      'comentarios': comentarios,
      'recordatorio': recordatorio,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notificación guardada correctamente')),
        );
        //se genera notificacion
        final [en, numero, tiempo] = recordatorio.split(' ');
        NotificationService.init();
        NotificationService.scheduleReminder(
          id: 1,
          title: 'Notificacion',
          body: comentarios,
          number: int.parse(numero),
          time: tiempo,
        );
        Navigator.pop(context);
      } else {
        // Error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Error de conexión
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectar con la API: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50), // Verde
        title: const Text(
          'Registrar actividad',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Fecha", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}",
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Comentario",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.green[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("¿Deseas recibir un recordatorio?",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedReminder,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: reminderOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedReminder = newValue!;
                });
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _guardarNotificacion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  foregroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text("Guardar", style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
