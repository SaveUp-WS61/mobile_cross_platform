import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:saveup/utils/dbhelper.dart';
import 'package:intl/intl.dart';
import 'package:time_machine/time_machine.dart';

class HistoryBuysScreen extends StatefulWidget {
  const HistoryBuysScreen({Key? key}) : super(key: key);

  @override
  _HistoryBuysScreenState createState() => _HistoryBuysScreenState();
}

class _HistoryBuysScreenState extends State<HistoryBuysScreen> {
  late List<Map<String, dynamic>> _historyBuys;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _historyBuys = []; // Inicializar _historyBuys como una lista vacía
    // Llama a la función para obtener el historial de compras cuando se inicializa el widget
    _getHistoryBuys();
  }

  // Función para obtener el historial de compras desde la API
  Future<void> _getHistoryBuys() async {
    final accounts = await DbHelper().getAccounts();
    final account = accounts[0];

    try {
      final response = await http.get(
        Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/purchase/${account.tableId}/data'), // Reemplaza 1 con el ID correcto
      );

      if (response.statusCode == 200) {
        final List<dynamic> historyBuys = json.decode(response.body);
        setState(() {
          _historyBuys = List<Map<String, dynamic>>.from(historyBuys);
          _isLoading = false;
        });
      } else {
        // Manejar el error de la solicitud HTTP si es necesario
        print('Error en la solicitud. Código de estado: ${response.statusCode}');
        setState(() {
          _isLoading = false; // Marcar la solicitud como completada incluso en caso de error
        });
      }
    } catch (error) {
      // Manejar errores de red u otros errores
      print('Error: $error');
      setState(() {
        _isLoading = false; // Marcar la solicitud como completada incluso en caso de error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Compras'),
        centerTitle: true,
        backgroundColor: const Color(0xFF67C5C8),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _historyBuys.isNotEmpty
              ? _BuysView(historyBuys: _historyBuys)
              : const Center(child: Text('No hay historial de compras')),
    );
  }
}

class _BuysView extends StatelessWidget {
  final List<Map<String, dynamic>> historyBuys;

  const _BuysView({Key? key, required this.historyBuys}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(
            label: Container(
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF201F34),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Text(
                  'Nombre',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          DataColumn(
            label: Container(
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF201F34),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Text(
                  'Empresa',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          DataColumn(
            label: Container(
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF201F34),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Text(
                  'Fecha',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          DataColumn(
            label: Container(
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF201F34),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Text(
                  'Dirección',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
        rows: historyBuys.map<DataRow>((buy) {
          return DataRow(
            cells: [
              DataCell(
                Container(
                  height: 30,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE95D5D),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      buy['name'].toString(), // Reemplaza 'name' con la clave correcta
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              DataCell(
                Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE95D5D),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      buy['empresa'].toString(), // Reemplaza 'empresa' con la clave correcta
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              DataCell(
                Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE95D5D),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      _formatDate(buy['date']), // Reemplaza 'date' con la clave correcta
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              DataCell(
                Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE95D5D),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      buy['pay_address'].toString(), // Reemplaza 'estado' con la clave correcta
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date is int) {
      // Si 'date' es un entero, conviértelo a un objeto DateTime
      final dateTime = DateTime.fromMillisecondsSinceEpoch(date);
      // Luego, convierte a LocalDate o formatea directamente según tus necesidades
      final localDate = LocalDate(dateTime.year, dateTime.month, dateTime.day);
      return _formatLocalDate(localDate);
    } else if (date is LocalDate) {
      // Si 'date' ya es un objeto LocalDate, simplemente formatea
      return _formatLocalDate(date);
    } else {
      // En caso contrario, devuelve una cadena vacía o maneja según tus necesidades
      return '';
    }
  }

  String _formatLocalDate(LocalDate localDate) {
    // Formatea la fecha usando DateTimeFormatter
    final formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(localDate.toDateTimeUnspecified());
  }
}
