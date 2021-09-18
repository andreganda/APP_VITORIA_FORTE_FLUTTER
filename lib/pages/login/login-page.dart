import 'dart:convert';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitoria_forte/Model/Usuario.dart';
import 'package:vitoria_forte/pages/index.dart';
import 'package:vitoria_forte/pages/login/novo-usuario.dart';
import 'package:vitoria_forte/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _getUser();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  var _login = TextEditingController();
  var _senha = TextEditingController();
  var _cpfRecuperar = TextEditingController();

  bool _logando = true;
  bool _passwordVisible = false;
  bool _callCircular = false;
  bool _esqueciSenha = false;
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return _logando
        ? _buildPreparacao()
        : Scaffold(
            backgroundColor: Colors.white,
            body: _esqueciSenha
                ? _buildContainerRecuperarSenha()
                : SingleChildScrollView(
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
                            textInputAction:
                                TextInputAction.next, // Moves focus to next.
                            keyboardType: TextInputType.number,
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
                          child: TextField(
                            onSubmitted: (value) {
                              logar(
                                  this._login.text, this._senha.text, context);
                            },
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
                          onPressed: () {
                            setState(() {
                              _esqueciSenha = true;
                            });
                          },
                          child: Text(
                            'Esqueci minha senha',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20)),
                          child: FlatButton(
                            onPressed: () {
                              logar(
                                  this._login.text, this._senha.text, context);
                            },
                            child: _callCircular
                                ? CircularProgressIndicator(
                                    backgroundColor: Colors.grey,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black))
                                : Text(
                                    'Logar',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 130,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => NovoUsuarioPage()));
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

  Widget _buildPreparacao() {
    return Material(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text("Estamos preparando tudo para você. Aguarde ....",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                )),
          ),
        ),
      ),
    );
  }

  Future logar(String login, String senha, BuildContext context) async {
    try {
      if (login.isEmpty || senha.isEmpty) {
        showAlertDialog(context, "INSIRA UM LOGIN E/OU SENHA");
      } else {
        setState(() {
          _callCircular = true;
        });

        // Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(builder: (context) => IndexPage()));

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
          _saveUserLocalStore(response.body);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => IndexPage()));
        } else {
          // throw Exception('Failed to create album.');
        }
      }
    } catch (e) {
      print(e);
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

  Widget _buildContainerRecuperarSenha() {
    return Center(
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'INSIRA SEU EMAIL',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildEmail(),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      onPressed: () {
                        if (_cpfRecuperar.value.text.isEmpty) {
                          showAlertDialog(context,
                              "Insira um cpf para recuperação de senha");
                        } else {
                          if (_cpfRecuperar.value.text.length != 14) {
                            showAlertDialog(context,
                                "Insira um cpf válido para recuperação de senha");
                          }
                        }
                      },
                      child: Text(
                        'Enviar',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          _esqueciSenha = false;
                        });
                      },
                      child: Text(
                        'Voltar',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        height: 300,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.amberAccent,
          border: Border.all(
              color: Colors.black, // Set border color
              width: 3.0),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildEmail() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
      child: Center(
        child: TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CpfInputFormatter(),
          ],
          keyboardType: TextInputType.number,
          controller: _cpfRecuperar,
          decoration: InputDecoration(
            labelText: 'CPF',
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

      if (user != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => IndexPage()));
      }
    } catch (e) {
      setState(() {
        _logando = false;
      });
    }
  }
}

_saveUserLocalStore(String userJson) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userJson', userJson);
}
