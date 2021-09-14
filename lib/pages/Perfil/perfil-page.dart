import 'package:flutter/material.dart';
import 'package:vitoria_forte/widget/menu-widget.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Perfil',
        ),
        leading: MenuWidget(),
      ),
    );
  }
}
