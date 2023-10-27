import 'package:flutter/material.dart';

class NavbarScreen extends StatelessWidget {
  const NavbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Marzzio Chicana"),
            accountEmail: const Text("marzzio@gmail.com"),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Transform.scale(
                  scale: 1.3,
                  child: Image.asset("assets/profile.jpg"),
                ),
              ),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/background_profile.jpg"), fit: BoxFit.cover)
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Pagina principal"),
            onTap: () {print("Pagina principal");},
          ),
          ListTile(
            leading: Icon(Icons.inbox),
            title: Text("Bandeja de entrada"),
            onTap: () {print("Bandeja de entrada");},
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Perfil"),
            onTap: () {print("Perfil");},
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text("Historial"),
            onTap: () {print("Historial");},
          ),
          Expanded(
            child: Container(),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Cerrar sesión"),
            onTap: () {print("Cerrar sesión");},
          ),
        ],
      ),
    );
  }
}
