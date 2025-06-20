import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AsesoramientoEspecialistaScreen extends StatefulWidget {
  const AsesoramientoEspecialistaScreen({super.key});

  @override
  State<AsesoramientoEspecialistaScreen> createState() =>
      _AsesoramientoEspecialistaScreen();
}

class _AsesoramientoEspecialistaScreen
    extends State<AsesoramientoEspecialistaScreen> {
  DateTime? _selectedDate;
  int _selectedMonthIndex = DateTime.now().month - 1;
  int _selectedYear = 2025;

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  Future<void> _selectDateDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecciona la fecha'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        setState(() {
                          if (_selectedMonthIndex > 0) {
                            _selectedMonthIndex--;
                          } else {
                            _selectedYear--;
                            _selectedMonthIndex = 11;
                          }
                        });
                      },
                    ),
                    Text(
                      '${_months[_selectedMonthIndex]} $_selectedYear',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        setState(() {
                          if (_selectedMonthIndex < 11) {
                            _selectedMonthIndex++;
                          } else {
                            _selectedYear++;
                            _selectedMonthIndex = 0;
                          }
                        });
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: DateTime(
                      _selectedYear,
                      _selectedMonthIndex + 2,
                      0,
                    ).day,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                    ),
                    itemBuilder: (context, index) {
                      final day = index + 1;
                      final currentDate =
                          DateTime(_selectedYear, _selectedMonthIndex + 1, day);
                      final isSelected = _selectedDate != null &&
                          _selectedDate!.year == _selectedYear &&
                          _selectedDate!.month == _selectedMonthIndex + 1 &&
                          _selectedDate!.day == day;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedDate = currentDate;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Text(
                            '$day',
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Asesoramiento por especialista',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              20), // Ajusta el valor para más/menos redondeo
                          child: Image.asset(
                            'assets/asesoramiento_humano.png',
                            width: 200,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Card(
                    color: Colors.white.withOpacity(0.8),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Tu cita ha sido confirmada',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          const Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black54,
                            ),
                          ),
                          InkWell(
                            onTap: () => _selectDateDialog(context),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                suffixIcon: const Icon(Icons.calendar_today),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 12.0),
                                child: Text(
                                  _selectedDate != null
                                      ? DateFormat('MM/dd/yyyy')
                                          .format(_selectedDate!)
                                      : 'MM/DD/YYYY',
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          const Text(
                            'MM/DD/YYYY',
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
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
          ),
        ],
      ),
    );
  }
}

class PersonalDataScreen extends StatelessWidget {
  const PersonalDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos Personales'),
      ),
      body: const Center(
        child: Text('Pantalla de Datos Personales'),
      ),
    );
  }
}
