import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:vitoria_forte/Model/Usuario.dart';
import 'package:vitoria_forte/widget/textfield_widget.dart';

import '../../constants.dart';

class PrimeiroAcessoPage extends StatefulWidget {
  @override
  _PrimeiroAcessoPageState createState() => _PrimeiroAcessoPageState();
}

class _PrimeiroAcessoPageState extends State<PrimeiroAcessoPage> {
  String _cpf;
  var _cpfController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Usuario usuarioPage = new Usuario();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Primeiro acesso'),
      ),
      body: Container(
          margin: EdgeInsets.all(24),
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildCpf(),
              ],
            ),
          )),
    );
  }

  Widget _buildCpf() {
    return TextFormField(
      controller: _cpfController,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CpfInputFormatter(),
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'CPF',
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
            icon: Icon(
              Icons.search,
              size: 35,
              color: Colors.blue,
            ),
            onPressed: () {
              _buscarCpf();
            }),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'campo obrigatório';
        } else {
          if (value.length != 14) {
            return 'CPF deve possuir 11 digitos';
          }
        }
      },
      onSaved: (String value) {
        _cpf = value;
      },
    );
  }

  void _buscarCpf() {
    //_confirmacaoDadosUsuario(null);
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();
      _primeiroAcessoRequisicao(_cpf);
    }
  }

  void _carregando(String msg) {
    AlertDialog dialog = new AlertDialog(
      content: new Container(
        width: 260.0,
        height: 120.0,
        child: Center(
          child: Column(
            children: [
              Text(
                msg,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  void _mensagemUsuario(String msg) {
    AlertDialog dialog = new AlertDialog(
      actions: <Widget>[
        // define os botões na base do dialogo
        new FlatButton(
          child: new Text("Fechar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      content: new Container(
        width: 260.0,
        height: 200.0,
        child: Center(
          child: Column(
            children: [
              Text(
                msg,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  void _confirmacaoDadosUsuario(Usuario user) {
    var btnConfirmacao = Container(
      width: 60,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Center(
        child: Text(
          'SIM',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );

    var btnConfirmacaoNegativa = Container(
      width: 60,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Center(
        child: Text(
          'NÃO',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );

    AlertDialog dialog = new AlertDialog(
      content: new Container(
        width: 260.0,
        height: 400.0,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 2),
          children: [
            TextFieldWidget(
              label: 'NOME:',
              text: user.nome.toString(),
            ),
            SizedBox(height: 15),
            TextFieldWidget(
              label: 'CPF:',
              text: user.cpf.toString(),
            ),
            SizedBox(height: 15),
            TextFieldWidget(
              label: 'E-MAIL:',
              text: user.email.toString(),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'SEUS DADOS ESTÃO CORRETOS?',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            child: btnConfirmacao,
                            onTap: () {
                              Navigator.of(context).pop();
                              _enviarSenha(_cpf);
                            }),
                        SizedBox(width: 50),
                        GestureDetector(
                          child: btnConfirmacaoNegativa,
                          onTap: () {
                            Navigator.of(context).pop();
                            _mensagemUsuario(
                                "Contate a administração do condomínio para alterar seus dados.");
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            )
          ],
        ),
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  void _primeiroAcessoRequisicao(String cpf) async {
    _carregando("Buscando CPF....");
    try {
      final response = await http.get(
          Uri.parse('${baseUrl}Login/primeiro_acesso?cpf=' + cpf),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body != "") {
          Map<String, dynamic> userMap = jsonDecode(response.body);
          Usuario user = new Usuario();
          user = Usuario.fromJson(userMap);
          usuarioPage = user;
          Navigator.of(context).pop();
          _confirmacaoDadosUsuario(user);
        } else {
          Navigator.of(context).pop();
          _mensagemUsuario(
              "CPF NÃO ENCONTRADO. \n\nContate a administração do condomínio.");
        }
      }
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
      _mensagemUsuario("Aconteceu um problema, tente novamente.");
    }
  }

  void _enviarSenha(String cpf) async {
    _carregando("Enviando email de confirmação");
    try {
      final response = await http.get(
          Uri.parse('${baseUrl}Login/enviar_senha_provisoria?cpf=' + cpf),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body != "") {
          Map<String, dynamic> userMap = jsonDecode(response.body);
          Usuario user = new Usuario();
          user = Usuario.fromJson(userMap);
          Navigator.of(context).pop();
          _mensagemUsuario("Enviamos uma senha provisória para o email " +
              usuarioPage.email);
        } else {
          Navigator.of(context).pop();
          _mensagemUsuario(
              "Aconteceu um problema ao enviar a senha para o email ${usuarioPage.email}, tente novamente.");
        }
      }
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
      _mensagemUsuario(
          "Aconteceu um problema ao enviar senha, tente novamente.");
    }
  }
}
