import 'package:flutter/material.dart';
import 'package:saveup/models/account.dart';
import 'package:saveup/utils/dbhelper.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  String accountType = '';
  Map<String, dynamic> accountData = {};

  @override
  void initState() {
    super.initState();
    loadAccount();
  }

  Future<void> loadAccount() async {
    final accounts = await DbHelper().getAccounts();
    final account = accounts[0];
    setState(() {
      accountData = account.toMap();
      accountType = accountData['type'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(accountData['name']??'Sin nombre'),
            accountEmail: Text(accountData['email']??'Sin correo'),
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
            onTap: () async {
              final accounts = await DbHelper().getAccounts();

              if(accountData != null) {
                if (accountType == 'customer') {
                  Navigator.of(context).pushNamed("products");
                } else if (accountType == 'company') {
                  Navigator.of(context).pushNamed("company_products");
                }
              }
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
              final accounts = await DbHelper().getAccounts();

              if(accountData != null) {
                if (accountType == 'customer') {
                  Navigator.of(context).pushNamed("profile");
                } else if (accountType == 'company') {
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