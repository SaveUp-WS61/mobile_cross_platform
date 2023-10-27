import 'package:flutter/material.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("SaveUp"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: (){ Navigator.of(context).pushNamed("cart"); },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: (){ Navigator.of(context).pushNamed("search_products"); },
          )
        ],
        backgroundColor: const Color.fromARGB(255, 103, 197, 200),
        /*
        leading: IconButton(
          icon: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: (){}
          ),
          onPressed: (){}
        ),*/
    );
  }
}