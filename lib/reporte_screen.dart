import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReportesGanaderoScreen extends StatefulWidget {
  const ReportesGanaderoScreen({super.key});

  @override
  State<ReportesGanaderoScreen> createState() => _ReportesGanaderoScreenState();
}

class _ReportesGanaderoScreenState extends State<ReportesGanaderoScreen> {
  String? filtro;
  String? tipoGanado;

  final TextEditingController _numeroCabezasController =
      TextEditingController();
  final TextEditingController _pesoPromedioController = TextEditingController();
  final TextEditingController _alimentacionController = TextEditingController();
  final TextEditingController _duracionController = TextEditingController();
  final TextEditingController _costoController = TextEditingController();

  final List<String> filtros = ['Filtrar por', 'Fecha', 'Tipo de ganado'];
  final List<String> tiposGanado = [
    'Tipo de ganado',
    'Vacuno',
    'Porcino',
    'Caprino'
  ];

  @override
  void dispose() {
    _numeroCabezasController.dispose();
    _pesoPromedioController.dispose();
    _alimentacionController.dispose();
    _duracionController.dispose();
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
                    const SizedBox(height: 50),
                    const Text(
                      'Reportes y\nseguimiento ganadero',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildDropdown(filtros, filtro, (value) {
                      setState(() => filtro = value);
                    }),
                    const SizedBox(height: 15),
                    _buildDropdown(tiposGanado, tipoGanado, (value) {
                      setState(() => tipoGanado = value);
                    }),
                    const SizedBox(height: 15),
                    _buildTextField(
                        _numeroCabezasController, 'Número de cabezas'),
                    const SizedBox(height: 15),
                    _buildTextField(
                        _pesoPromedioController, 'Peso promedio (kg)'),
                    const SizedBox(height: 15),
                    _buildTextField(
                        _alimentacionController, 'Alimentación (kg)'),
                    const SizedBox(height: 15),
                    _buildTextField(_duracionController, 'Duración (días)'),
                    const SizedBox(height: 15),
                    _buildTextField(
                        _costoController, 'Costo de alimentación (S/)'),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () async {
                        await enviarDatos();
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

    final url = Uri.parse(
        'https://api-agri-cria-production.up.railway.app/api/reportesGanadero');
    //final url = Uri.parse('http://localhost:3000/api/reportesGanadero');

    final Map<String, dynamic> data = {
      'filtro': filtro,
      'tipoGanado': tipoGanado,
      'numeroCabezas': _numeroCabezasController.text,
      'pesoPromedio': _pesoPromedioController.text,
      'alimentacion': _alimentacionController.text,
      'duracion': _duracionController.text,
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
              content: Text('Error: ${response.statusCode}. ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar datos: $e')),
      );
    }
  }
}
