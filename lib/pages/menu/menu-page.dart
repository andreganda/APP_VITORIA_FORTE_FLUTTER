import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitoria_forte/Model/Usuario.dart';
import 'package:vitoria_forte/Model/menu_item.dart';
import 'package:vitoria_forte/pages/login/login-page.dart';

class MenuItems {
  static const home = MenuItem('Início', Icons.home);
  static const botaoPanico = MenuItem('Socorro', Icons.dangerous);
  static const denuncia = MenuItem('Denunciar', Icons.contact_phone);
  static const perfil = MenuItem('Perfil', Icons.supervised_user_circle_sharp);

  static const all = <MenuItem>[home, denuncia, botaoPanico, perfil];
}

class MenuPage extends StatefulWidget {
  final MenuItem currentItem;
  final ValueChanged<MenuItem> onSelectedItem;

  const MenuPage({
    Key key,
    this.currentItem,
    this.onSelectedItem,
  }) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Usuario userPage = new Usuario();

  @override
  void initState() {
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Colors.indigo,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(),
                title: Text(this.userPage.nome.toString()),
                subtitle: Text("Morador"),
              ),
              Spacer(),
              ...MenuItems.all.map(buildMenuItem).toList(),
              Spacer(
                flex: 2,
              ),
              buildBtnLogout(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(MenuItem item) => ListTileTheme(
        child: ListTile(
          selected: widget.currentItem == item,
          selectedTileColor: Colors.black12,
          title: Text(
            item.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            widget.onSelectedItem(item);
          },
          leading: Icon(
            item.icon,
          ),
        ),
      );

  Widget buildBtnLogout(BuildContext context) => ListTileTheme(
        child: ListTile(
          selectedTileColor: Colors.black12,
          title: Text(
            "Sair",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()));
          },
          leading: Icon(Icons.logout),
        ),
      );

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> userMap = jsonDecode(prefs.getString('userJson'));
      Usuario user = new Usuario();
      user = Usuario.fromJson(userMap);
      this.userPage = user;
    } catch (e) {}
  }
}
