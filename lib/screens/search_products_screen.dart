import 'package:flutter/material.dart';
import 'package:saveup/widgets/bar/navbar.dart';
import 'package:saveup/widgets/bar/toolbar.dart';

class Product {
  final String name;
  final String expirationDate;
  final double price;
  final int stock;
  int unit;

  Product({
    required this.name,
    required this.expirationDate,
    required this.price,
    required this.stock,
    required this.unit,
  });
}

class SearchProductsScreen extends StatefulWidget {
  const SearchProductsScreen({super.key});

  @override
  State<SearchProductsScreen> createState() => _SearchProductsScreenState();
}

class _SearchProductsScreenState extends State<SearchProductsScreen> {
  final List<Product> products = [
    Product(
      name: 'Coca cola',
      expirationDate: '20-05-2023',
      price: 13.00,
      stock: 120,
      unit: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Toolbar(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar productos',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: Image.asset('assets/coca_cola.jpg'),
                  title: Text(product.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha de vencimiento: ${product.expirationDate}'),
                      Text('Precio: S/${product.price.toStringAsFixed(2)}'),
                      Text('Stock: ${product.stock}'),
                      Row(
                        children: [
                          Text('Unidad: ${product.unit}'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                product.unit = product.unit + 1;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.shopping_cart),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}