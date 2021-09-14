import 'package:flutter/material.dart';
import 'package:vitoria_forte/widget/menu-widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'Inicio',
        ),
        leading: MenuWidget(),
      ),
    );
  }
}
