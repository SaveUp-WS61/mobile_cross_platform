import 'package:flutter/material.dart';

class CompanyToolbar extends StatelessWidget {
  const CompanyToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("SaveUp"),
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