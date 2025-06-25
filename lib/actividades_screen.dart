import 'package:agri_cria_app/detalle_actividad_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ActividadesScreen extends StatefulWidget {
  const ActividadesScreen({super.key});

  @override
  State<ActividadesScreen> createState() => _ActividadesScreenState();
}

class _ActividadesScreenState extends State<ActividadesScreen> {
  List<Map<String, dynamic>> actividades = [];
  bool cargando = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchActividades();
  }

  Future<void> fetchActividades() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token no disponible. Inicia sesión de nuevo.');
    }

    const url =
        'https://api-agri-cria-production.up.railway.app/api/traeActividades';
    //const url = 'http://localhost:3000/api/traeActividades';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          actividades = data
              .map((item) => {
                    'titulo': 'Actividad', //item['titulo'] ?? 'Sin título',
                    'fecha': item['fecha'] ?? '',
                    'comentario': item['comentarios'] ?? '',
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
              child: Text(
                'Actividades',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: cargando
                  ? const Center(child: CircularProgressIndicator())
                  : error != null
                      ? Center(
                          child: Text(
                            error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : actividades.isEmpty
                          ? const Center(
                              child: Text(
                                'No se encontraron actividades',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: actividades.length,
                              itemBuilder: (context, index) {
                                final actividad = actividades[index];
                                return Column(
                                  children: [
                                    _buildActivityCard(
                                      context,
                                      actividad['titulo']?.toString() ?? '',
                                      actividad['fecha']?.toString() ?? '',
                                      actividad['comentario'] ?? '',
                                    ),
                                    const SizedBox(height: 16.0),
                                  ],
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black54,
        padding: const EdgeInsets.symmetric(vertical: 12),
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
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(
      BuildContext context, String title, String fecha, String subtitle) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style:
                        const TextStyle(fontSize: 16.0, color: Colors.black54),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetalleActividadScreen(
                      fecha: fecha,
                      comentario: subtitle,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[600],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Text(
                'Ver',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
