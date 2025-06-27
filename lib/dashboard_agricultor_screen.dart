import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardAgricultorScreen extends StatelessWidget {
  const DashboardAgricultorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: const BoxDecoration(
              color: Colors.green,
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
                            final hectareasTotales =
                                data['hectareasTotales'] ?? 0;
                            final actividadesTotales =
                                data['actividadesTotales'] ?? 0;
                            final volumenHumedad =
                                List<Map<String, dynamic>>.from(
                                    data['volumenHumedad']);
                            final duracionVolumen =
                                List<Map<String, dynamic>>.from(
                                    data['duracionVolumen']);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        16.0), // Un poco de padding alrededor
                                    child: Row(
                                      children: <Widget>[
                                        // Primera Card
                                        Expanded(
                                          child: Card(
                                            color: const Color(
                                                0xFF388E3C), // Dark green
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Hectáreas totales',
                                                    style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 16),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    '$hectareasTotales',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 32,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const Text(
                                                    'este mes',
                                                    style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        //segunda card
                                        Expanded(
                                          child: Card(
                                            color: const Color(
                                                0xFF673AB7), // Deep Purple
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Actividades',
                                                    style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 16),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '$actividadesTotales',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 32,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      const Text(
                                                        '+25%',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .greenAccent,
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                                  const Text(
                                                    'este mes',
                                                    style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Card de Resumen
                                Card(
                                  color: const Color(0xFF4CAF50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Resumen',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
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
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Card: Volumen vs Humedad (Bar Chart)
                                Card(
                                  color: Colors.orange[700],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Volumen vs Humedad',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          height: 200,
                                          child: BarChart(
                                            BarChartData(
                                              barGroups: volumenHumedad
                                                  .asMap()
                                                  .entries
                                                  .map((entry) {
                                                final index = entry.key;
                                                final item = entry.value;
                                                return BarChartGroupData(
                                                    x: index,
                                                    barRods: [
                                                      BarChartRodData(
                                                          toY:
                                                              (item['volumen'] ??
                                                                      0)
                                                                  .toDouble(),
                                                          color: Colors.white)
                                                    ]);
                                              }).toList(),
                                              gridData:
                                                  const FlGridData(show: true),
                                              borderData:
                                                  FlBorderData(show: false),
                                              titlesData: FlTitlesData(
                                                leftTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    getTitlesWidget:
                                                        (value, meta) => Text(
                                                            '${value.toInt()}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                  ),
                                                ),
                                                bottomTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    getTitlesWidget:
                                                        (value, meta) {
                                                      final labels =
                                                          volumenHumedad
                                                              .map((e) => e[
                                                                      'humedad']
                                                                  .toString())
                                                              .toList();
                                                      return value.toInt() <
                                                              labels.length
                                                          ? Text(
                                                              labels[value
                                                                  .toInt()],
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white))
                                                          : const Text('');
                                                    },
                                                  ),
                                                ),
                                                topTitles: const AxisTitles(
                                                    sideTitles: SideTitles(
                                                        showTitles: false)),
                                                rightTitles: const AxisTitles(
                                                    sideTitles: SideTitles(
                                                        showTitles: false)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Card: Duración y Volumen (Scatter Chart)
                                Card(
                                  color: Colors.blue[700],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Duración y Volumen',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          height: 200,
                                          child: ScatterChart(
                                            ScatterChartData(
                                              scatterSpots:
                                                  duracionVolumen.map((item) {
                                                return ScatterSpot(
                                                  (item['duracion'] ?? 0)
                                                      .toDouble(),
                                                  (item['volumen'] ?? 0)
                                                      .toDouble(),
                                                  color: Colors.white,
                                                );
                                              }).toList(),
                                              minX: 0,
                                              maxX: 50,
                                              minY: 0,
                                              maxY: 100,
                                              gridData:
                                                  const FlGridData(show: true),
                                              borderData:
                                                  FlBorderData(show: true),
                                              titlesData: FlTitlesData(
                                                leftTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    getTitlesWidget:
                                                        (value, meta) => Text(
                                                            '${value.toInt()}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                  ),
                                                ),
                                                bottomTitles: AxisTitles(
                                                  sideTitles: SideTitles(
                                                    showTitles: true,
                                                    getTitlesWidget:
                                                        (value, meta) => Text(
                                                            '${value.toInt()}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                  ),
                                                ),
                                                topTitles: const AxisTitles(
                                                    sideTitles: SideTitles(
                                                        showTitles: false)),
                                                rightTitles: const AxisTitles(
                                                    sideTitles: SideTitles(
                                                        showTitles: false)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
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
  //const url = 'http://localhost:3000/api/dashboard';

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
