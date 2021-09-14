import 'package:flutter/material.dart';
import 'package:vitoria_forte/Model/menu_item.dart';
import 'package:vitoria_forte/pages/login/login-page.dart';

class MenuItems {
  static const home = MenuItem('Início', Icons.home);
  static const botaoPanico = MenuItem('Socorro', Icons.dangerous);
  static const denuncia = MenuItem('Denunciar', Icons.contact_phone);
  static const perfil = MenuItem('Perfil', Icons.supervised_user_circle_sharp);

  static const all = <MenuItem>[home, denuncia, botaoPanico, perfil];
}

class MenuPage extends StatelessWidget {
  final MenuItem currentItem;
  final ValueChanged<MenuItem> onSelectedItem;

  const MenuPage({
    Key key,
    this.currentItem,
    this.onSelectedItem,
  }) : super(key: key);

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
                title: Text("ANDRÉ FELIPE MORAIS RODRIGUES"),
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
          selected: currentItem == item,
          selectedTileColor: Colors.black12,
          title: Text(
            item.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            onSelectedItem(item);
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
}
