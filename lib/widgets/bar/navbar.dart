import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:saveup/utils/dbhelper.dart';
import 'package:http/http.dart' as http;


class Navbar extends StatelessWidget {

  String userType = '';
  Map<String, dynamic> userData = {};

  Future<void> loadUser() async {
    final users = await DbHelper().getUsers();
    final userAccount = users[0];

    userType = userAccount.type;
    if(userType=='customer') {
      final response = await http.get(Uri.parse(
        'https://saveup-production.up.railway.app/api/saveup/v1/customers/${userAccount.tableId}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        userData = data;
      }
    }
    else if(userType=='company') {
      final response = await http.get(Uri.parse('https://saveup-production.up.railway.app/api/saveup/v1/companies'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        for(var company in data) {
          if(company['id'] == users[0].tableId) {
            userData = company;
            break;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context){
    loadUser();
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userData['name']??'Sin nombre'),
            accountEmail: Text(userData['email']??'Sin correo'),
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
              final users = await DbHelper().getUsers();

              if(users[0] != null) {
                final userType = users[0].type;

                if (userType == 'customer') {
                  Navigator.of(context).pushNamed("products");
                } else if (userType == 'company') {
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