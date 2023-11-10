import 'package:flutter/material.dart';
import 'package:saveup/utils/dbhelper.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

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
                image: DecorationImage(
                    image: AssetImage("assets/background_profile.jpg"),
                    fit: BoxFit.cover)),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Pagina principal"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("products");
            },
          ),
          ListTile(
            leading: Icon(Icons.inbox),
            title: Text("Bandeja de entrada"),
            onTap: () {
              Navigator.of(context).pushNamed("bot_chat");
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Perfil"),
            onTap: () async {
              final users = await DbHelper().getUsers();

              if(users[0] != null) {
                final userType = users[0].type;

                if (userType == 'customer') {
                  Navigator.of(context).pushNamed("profile");
                } else if (userType == 'company') {
                  Navigator.of(context).pushNamed("company_profile");
                }
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text("Historial"),
            onTap: () {
              Navigator.of(context).pushNamed("history_buys");
            },
          ),
          Expanded(
            child: Container(),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Cerrar sesión"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("logout");
            },
          ),
        ],
      ),
    );
  }
}
