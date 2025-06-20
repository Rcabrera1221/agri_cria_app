import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardAgricultorScreen extends StatelessWidget {
  const DashboardAgricultorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[200], // A light background color for the overall screen
      body: Column(
        children: <Widget>[
          // Top Green Dashboard Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: const BoxDecoration(
              color: Colors.green, // Darker green for the header
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
                opacity: 0.2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.person, color: Colors.white, size: 30),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        // Hectáreas totales Card
                        Expanded(
                          child: Card(
                            color: const Color(0xFF388E3C), // Dark green
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hectáreas totales',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 16),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '32',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'este mes',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Actividades Card
                        Expanded(
                          child: Card(
                            color: const Color(0xFF673AB7), // Deep Purple
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Actividades',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 16),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        '12',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '+25%',
                                        style: TextStyle(
                                            color: Colors.greenAccent,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'este mes',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Resumen Card
                    // Resumen Card con datos desde API
                    Card(
                      color: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FutureBuilder<Map<String, dynamic>>(
                          future: fetchDashboardData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white));
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}',
                                  style: const TextStyle(color: Colors.white));
                            } else if (!snapshot.hasData) {
                              return const Text('Sin datos',
                                  style: TextStyle(color: Colors.white));
                            }

                            final data = snapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Resumen',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                _buildSummaryRow(Icons.water_drop,
                                    'Total de riego: ${data['totalRiego']}'),
                                _buildSummaryRow(Icons.local_drink,
                                    'Litros/ha: ${data['litroPorHa']}'),
                                _buildSummaryRow(Icons.thermostat,
                                    'Humedad media: ${data['humedadMedia']}%'),
                                _buildSummaryRow(Icons.attach_money,
                                    'Costo por ha: \$${data['costoPorHa']}'),
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        // 10 Alertas Card
                        Expanded(
                          child: Card(
                            color: const Color(0xFFD32F2F), // Red for alerts
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.notifications,
                                      color: Colors.white, size: 40),
                                  SizedBox(height: 8),
                                  Text(
                                    '10 alertas',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Line Chart Placeholder
                        Expanded(
                          child: Card(
                            color:
                                const Color(0xFF4CAF50), // Green for Line Chart
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: const SizedBox(
                              height:
                                  120, // Adjust height as needed for the chart
                              child: Center(
                                child: Text(
                                  'Line chart',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Custom Bottom Navigation Bar (reused from previous requests)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.black54.withOpacity(0.99),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white),
                  onPressed: () {
                    // Navigate to home
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    // Open menu
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(context, '/datosPersonales');
                  },
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
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

Future<Map<String, dynamic>> fetchDashboardData() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) {
    throw Exception('Token no disponible. Inicia sesión de nuevo.');
  }

  const url = 'https://api-agri-cria-production.up.railway.app/api/dashboard';

  final response = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al cargar datos del dashboard');
  }
}
