import 'package:flutter/material.dart';

/*class AppbarScreen extends StatelessWidget {
  const AppbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SaveUp"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: (){},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: (){},
          )
        ],
        backgroundColor: const Color.fromARGB(255, 103, 197, 200),
        leading: IconButton(
          icon: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: (){}
          ),
          onPressed: (){}
        ),
      ),
    );
  }
} */

class AppbarScreen extends StatelessWidget {
  const AppbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("SaveUp"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: (){},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: (){},
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