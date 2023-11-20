import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:saveup/utils/dbhelper.dart';
import 'package:intl/intl.dart';
import 'package:time_machine/time_machine.dart';

class HistorySalesScreen extends StatefulWidget {
  const HistorySalesScreen({Key? key}) : super(key: key);

  @override
  _HistorySalesScreenState createState() => _HistorySalesScreenState();
}

class _HistorySalesScreenState extends State<HistorySalesScreen> {
  late List<Map<String, dynamic>> _historySales;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _historySales = [];
    _getHistorySales();
  }

  Future<void> _getHistorySales() async {
    final accounts = await DbHelper().getAccounts();
    final account = accounts[0];

    final response = await http.get(
      Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/sale/${account.tableId}/data'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> historySales = json.decode(response.body);
      setState(() {
        _historySales = List<Map<String, dynamic>>.from(historySales);
        _isLoading = false;
      });
    } else {
      print('Error en la solicitud. Código de estado: ${response.statusCode}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Ventas'),
        centerTitle: true,
        backgroundColor: const Color(0xFF67C5C8),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _historySales.isNotEmpty
              ? _SalesView(historySales: _historySales)
              : const Center(child: Text('No hay historial de ventas')),
    );
  }
}

class _SalesView extends StatelessWidget {
  final List<Map<String, dynamic>> historySales;

  const _SalesView({Key? key, required this.historySales}) : super(key: key);

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
                  'Apellido',
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
                  'Orden',
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
                  'Producto',
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
                  'Monto',
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
                  'Cantidad',
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
        ],
        rows: historySales.map<DataRow>((sale) {
          return DataRow(
            cells: [
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
                      sale['name'].toString(), // Reemplaza 'dato1' con la clave correcta
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
                      sale['last_name'].toString(), // Reemplaza 'dato2' con la clave correcta
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
                      sale['orders'].toString(), // Reemplaza 'dato3' con la clave correcta
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              DataCell(
                Container(
                  height: 30,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE95D5D),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      sale['producto'].toString(), // Reemplaza 'dato4' con la clave correcta
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
                      sale['price'].toString(), // Reemplaza 'dato5' con la clave correcta
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
                      sale['quantity'].toString(), // Reemplaza 'dato6' con la clave correcta
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
                      _formatDate(sale['date']), // Reemplaza 'dato7' con la clave correcta
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
