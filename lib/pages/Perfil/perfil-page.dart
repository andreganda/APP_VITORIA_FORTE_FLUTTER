import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitoria_forte/Model/Usuario.dart';
import 'package:vitoria_forte/widget/menu-widget.dart';
import 'package:vitoria_forte/widget/profile_widget.dart';
import 'package:vitoria_forte/widget/textfield_widget.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  Usuario userPage = new Usuario();

  @override
  void initState() {
    _getUser();
  }

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
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath:
                "https://sigeo.pm.es.gov.br//arquivos/relatorio_operacional/5BPM/relatorio_id_7135/14_9_2021_22_25_53_60_name_IMG-20210914-WA0022.jpg",
            onClicked: () {},
          ),
          SizedBox(height: 24),
          // Text(this.userPage.nome.toString()),
          TextFieldWidget(
            label: 'Nome:',
            text: this.userPage.nome.toString(),
          ),
          SizedBox(height: 15),
          TextFieldWidget(
            label: 'CPF:',
            text: this.userPage.cpf.toString(),
          ),
          SizedBox(height: 15),
          TextFieldWidget(
            label: 'Data Nascimento:',
            text: this.userPage.dataNascimento.toString(),
          ),
          SizedBox(height: 15),
          TextFieldWidget(
            label: 'Email:',
            text: this.userPage.email.toString(),
          ),
          SizedBox(height: 15),
          TextFieldWidget(
            label: 'Telefone:',
            text: this.userPage.telefone.toString(),
          ),
        ],
      ),
    );
  }

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> userMap = jsonDecode(prefs.getString('userJson'));
      Usuario user = new Usuario();
      user = Usuario.fromJson(userMap);
      setState(() {
        this.userPage = user;
      });
    } catch (e) {}
  }
}
