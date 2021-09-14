import 'package:flutter/material.dart';
import 'package:vitoria_forte/widget/menu-widget.dart';

class DenunciarPage extends StatefulWidget {
  @override
  _DenunciarPageState createState() => _DenunciarPageState();
}

class _DenunciarPageState extends State<DenunciarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gerar Denuncia"),
        leading: MenuWidget(),
      ),
    );
  }
}
