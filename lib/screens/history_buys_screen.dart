import 'package:flutter/material.dart';

class HistoryBuysScreen extends StatelessWidget {
  const HistoryBuysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Buys'),
        centerTitle: true,
        backgroundColor: const Color(0xFF67C5C8),
      ),
      body: _BuysView(),
    );
  }
}

class _BuysView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
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
                ), // Color de fondo de la columna 1
                child: const Center(
                    child: Text(
                  'Nombre',
                  style: TextStyle(
                    color: Colors.white, // Color de texto
                  ),
                )),
              ),
            ),
            DataColumn(
              label: Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF201F34),
                  borderRadius: BorderRadius.circular(50),
                ), // Color de fondo de la columna 1
                child: const Center(
                    child: Text(
                  'Empresa',
                  style: TextStyle(
                    color: Colors.white, // Color de texto
                  ),
                )),
              ),
            ),
            DataColumn(
              label: Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF201F34),
                  borderRadius: BorderRadius.circular(50),
                ), // Color de fondo de la columna 1
                child: const Center(
                    child: Text(
                  'Fecha y Hora',
                  style: TextStyle(
                    color: Colors.white, // Color de texto
                  ),
                )),
              ),
            ),
            DataColumn(
              label: Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF201F34),
                  borderRadius: BorderRadius.circular(50),
                ), // Color de fondo de la columna 1
                child: const Center(
                    child: Text(
                  'Estado',
                  style: TextStyle(
                    color: Colors.white, // Color de texto
                  ),
                )),
              ),
            ),
          ],
          rows: [
            DataRow(
                //color: MaterialStateProperty.all<Color>(const Color(0xFFE95D5D)), // Color de fondo de la primera fila

                cells: [
                  DataCell(Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE95D5D),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                          child: Text(
                        'Dato 1.1',
                        style: TextStyle(
                          color: Colors.black, // Color de texto
                        ),
                      )))),
                  DataCell(Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE95D5D),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                          child: Text(
                        'Dato 1.1',
                        style: TextStyle(
                          color: Colors.black, // Color de texto
                        ),
                      )))),
                  DataCell(Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE95D5D),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                          child: Text(
                        'Dato 1.1',
                        style: TextStyle(
                          color: Colors.black, // Color de texto
                        ),
                      )))),
                  DataCell(Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE95D5D),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                          child: Text(
                        'Dato 1.1',
                        style: TextStyle(
                          color: Colors.black, // Color de texto
                        ),
                      )))),
                ]),
            DataRow(
                //color: MaterialStateProperty.all<Color>(const Color(0xFFE95D5D)), // Color de fondo de la primera fila
                cells:  [
                  DataCell(Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE95D5D),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                          child: Text(
                        'Dato 1.1',
                        style: TextStyle(
                          color: Colors.black, // Color de texto
                        ),
                      )))),
                  DataCell(Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE95D5D),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                          child: Text(
                        'Dato 1.1',
                        style: TextStyle(
                          color: Colors.black, // Color de texto
                        ),
                      )))),
                  DataCell(Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE95D5D),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                          child: Text(
                        'Dato 1.1',
                        style: TextStyle(
                          color: Colors.black, // Color de texto
                        ),
                      )))),
                  DataCell(Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE95D5D),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                          child: Text(
                        'Dato 1.1',
                        style: TextStyle(
                          color: Colors.black, // Color de texto
                        ),
                      )))),
                ]),
            // Agrega más filas según tus datos
          ],
        ),
      ),
    );
  }
}
