import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreen();
}

class _NotificationsScreen extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notificaciones = [];
  bool cargando = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      setState(() {
        error = 'Token no disponible. Inicia sesión de nuevo.';
        cargando = false;
      });
      return;
    }
	
	const url = 'https://api-agri-cria-production.up.railway.app/api/traeNotificaciones';
    //const url = 'http://localhost:3000/api/traeNotificaciones';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          notificaciones = data
              .map((item) => {
                    'fecha': item['fecha'] ?? '',
                    'comentario': item['comentarios'] ?? '',
                    'recordatorio': item['recordatorio'] ?? '',
                  })
              .toList();
          cargando = false;
        });
      } else {
        setState(() {
          error = 'Error ${response.statusCode}: ${response.body}';
          cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error de conexión: $e';
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notificaciones y alertas',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          child: const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 10.0, right: 10.0),
              child: CircleAvatar(
                backgroundColor: Colors.white70,
                radius: 25,
                child: Icon(Icons.person, size: 30, color: Colors.green),
              ),
            ),
          ),
        ),
        toolbarHeight: 200,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/crearNotificacion');
                },
                icon: const Icon(Icons.add_alert),
                label: const Text('Crear notificación'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: cargando
                    ? const Center(child: CircularProgressIndicator())
                    : error != null
                        ? Center(child: Text(error!))
                        : notificaciones.isEmpty
                            ? const Center(child: Text("No hay notificaciones"))
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                itemCount: notificaciones.length,
                                itemBuilder: (context, index) {
                                  final notif = notificaciones[index];
                                  return NotificationTile(
                                    icon: Icons.notifications,
                                    title: notif['comentario'] ?? '',
                                    time: formateaTiempo(notif['recordatorio']),
                                  );
                                },
                              ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.black54.withOpacity(0.99),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(context, '/datosPersonales');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formateaTiempo(String input) {
    input = input.toLowerCase().replaceAll('en ', '').trim();

    input = input.replaceAll(' horas', 'h');
    input = input.replaceAll(' hora', 'h');
    input = input.replaceAll(' minutos', 'min');
    input = input.replaceAll(' minuto', 'min');
    input = input.replaceAll(' días', 'd');
    input = input.replaceAll(' día', 'd');

    return input;
  }
}

class NotificationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;

  const NotificationTile({
    super.key,
    required this.icon,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: Icon(icon, color: Colors.black54),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                time,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
