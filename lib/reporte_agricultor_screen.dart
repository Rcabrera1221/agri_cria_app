import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReportesAgricultorScreen extends StatefulWidget {
  const ReportesAgricultorScreen({super.key});

  @override
  State<ReportesAgricultorScreen> createState() =>
      _ReportesAgricultorScreenState();
}

class _ReportesAgricultorScreenState extends State<ReportesAgricultorScreen> {
  String? filtro;
  String? tipoActividad;
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _volumenController = TextEditingController();
  final TextEditingController _duracionController = TextEditingController();
  final TextEditingController _humedadController = TextEditingController();
  final TextEditingController _costoController = TextEditingController();

  final List<String> filtros = ['Filtrar por', 'Fecha', 'Tipo', 'Área'];
  final List<String> tiposActividad = [
    'Tipo de actividad',
    'Riego',
    'Fertilización',
    'Cosecha'
  ];

  @override
  void dispose() {
    _areaController.dispose();
    _volumenController.dispose();
    _duracionController.dispose();
    _humedadController.dispose();
    _costoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Reportes y seguimientos',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 60),
                    _buildDropdown(filtros, filtro, (value) {
                      setState(() => filtro = value);
                    }),
                    const SizedBox(height: 15),
                    _buildDropdown(tiposActividad, tipoActividad, (value) {
                      setState(() => tipoActividad = value);
                    }),
                    const SizedBox(height: 15),
                    _buildTextField(_areaController, 'Área'),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                            child: _buildTextField(
                                _volumenController, 'Volumen (L)')),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _buildTextField(
                                _duracionController, 'Duración (min)')),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                            child: _buildTextField(
                                _humedadController, 'Humedad (%)')),
                        const SizedBox(width: 10),
                        Expanded(
                            child: _buildTextField(
                                _costoController, 'Costo (S/)')),
                      ],
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () async {
                        await enviarDatos();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Datos enviados correctamente')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text('Entregar'),
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
                    onPressed: () {}),
                IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {}),
                IconButton(
                    icon: const Icon(Icons.person, color: Colors.white),
                    onPressed: () {}),
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

  Widget _buildDropdown(List<String> items, String? selectedValue,
      ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.lightGreenAccent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        hint: Text(items.first),
        isExpanded: true,
        underline: const SizedBox(),
        onChanged: onChanged,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.lightGreenAccent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Future<void> enviarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token no disponible. Inicia sesión de nuevo.');
    }

    final url = Uri.parse('https://api-agri-cria-production.up.railway.app/api/reportes');
    //final url = Uri.parse('http://localhost:3000/api/reportes');

    final Map<String, dynamic> data = {
      'filtro': filtro,
      'tipoActividad': tipoActividad,
      'area': _areaController.text,
      'volumen': _volumenController.text,
      'duracion': _duracionController.text,
      'humedad': _humedadController.text,
      'costo': _costoController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos enviados correctamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error: ${response.statusCode}. ${response.body}')), // Agregado response.body para más detalle
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar datos: $e')),
      );
    }
  }
}
