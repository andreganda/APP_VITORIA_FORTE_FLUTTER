import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitoria_forte/Model/Usuario.dart';
import 'package:vitoria_forte/widget/textfield_widget.dart';

class MinhaContaPage extends StatefulWidget {
  @override
  _MinhaContaPageState createState() => _MinhaContaPageState();
}

Usuario userPage = new Usuario();

class _MinhaContaPageState extends State<MinhaContaPage> {
  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('MINHA CONTA'),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldWidget(
                label: 'Nome:',
                text: userPage.nome.toString(),
              ),
              SizedBox(height: 15),
              TextFieldWidget(
                label: 'CPF:',
                text: userPage.cpf.toString(),
              ),
              SizedBox(height: 15),
              TextFieldWidget(
                label: 'Email:',
                text: userPage.email.toString(),
              ),
              SizedBox(height: 15),
              TextFieldWidget(
                label: 'Telefone:',
                text: userPage.telefone.toString(),
              ),
              SizedBox(height: 15),
              TextFieldWidget(
                label: 'Data de Nascimento:',
                text: userPage.dataNascimentoFormat.toString(),
              ),
              SizedBox(height: 15),
              TextFieldWidget(
                label: 'Data Criação Usuário:',
                text: userPage.dataCriacaoFormat.toString(),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
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
        userPage = user;
      });
    } catch (e) {}
  }
}
