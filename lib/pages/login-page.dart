import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:vitoria_forte/Model/Usuario.dart';
import 'package:vitoria_forte/pages/novo-usuario.dart';
import 'package:vitoria_forte/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _login = TextEditingController();
  var _senha = TextEditingController();
  bool _passwordVisible = false;
  bool _callCircular = false;
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset('asset/images/logo.png')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _login,
                inputFormatters: [
                  // obrigatório
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter(),
                ],
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'CPF',
                    hintText: 'Entre com seu cpf'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _senha,
                obscureText: !this._passwordVisible,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'SENHA',
                    hintText: 'Entre com sua senha'),
              ),
            ),
            FlatButton(
              onPressed: () {},
              child: Text(
                'Esqueci minha senha',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    _callCircular = true;
                  });
                  logar(this._login.text, this._senha.text, context);
                },
                child: _callCircular
                    ? CircularProgressIndicator(
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black))
                    : Text(
                        'Logar',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => NovoUsuarioPage()));
              },
              child: Text(
                'Novo usuário? Criar conta',
              ),
            )
          ],
        ),
      ),
    );
  }

  Future logar(String login, String senha, BuildContext context) async {
    try {
      if (false) {
        showAlertDialog(context, "INSIRA UM LOGIN E/OU SENHA");
      } else {
        // _carregando(context, 0);
        // var response = await http.get(Uri.encodeFull("${baseUrl}Login"),
        //     headers: {"Accept": "application/json"});
        // if (response.body != null) {
        //   print(response.body);
        // }

        final response = await http.post(
          Uri.parse('${baseUrl}Login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'Cpf': login,
            'Senha': senha,
          }),
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> userMap = jsonDecode(response.body);
          Usuario user = new Usuario();
          user = Usuario.fromJson(userMap);
          print(response.body);
        } else {
          // throw Exception('Failed to create album.');
        }
      }
    } catch (e) {
      setState(() {
        _callCircular = false;
      });
    }
  }

  showAlertDialog(BuildContext context, String text) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alerta = AlertDialog(
      title: Text("ATENÇÃO"),
      content: Text(text),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }
}
