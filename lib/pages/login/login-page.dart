import 'dart:async';
import 'dart:convert';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitoria_forte/Model/Usuario.dart';
import 'package:vitoria_forte/pages/index.dart';
import 'package:vitoria_forte/constants.dart';
import 'package:vitoria_forte/pages/login/acesso-inicial-page.dart';
// import 'package:connectivity/connectivity.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  // ConnectivityResult _connectionStatus = ConnectivityResult.none;
  // final Connectivity _connectivity = Connectivity();
  // StreamSubscription<ConnectivityResult> _connectivitySubscription;

  var token = "";

  final _firebaseMessaging = FirebaseMessaging.instance;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _firebaseMessaging.getToken().then((value) {
      token = value;
      print("TOKEN: "+value);
    });

    // initConnectivity();
    _getUser();

    //_determinePosition();
    _getCurrentLocation();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    final isBackground = state == AppLifecycleState.paused;

    if (!isBackground) {}
  }

  // Future<void> initConnectivity() async {
  //   ConnectivityResult result;
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } on PlatformException catch (e) {
  //     print(e.toString());
  //     return;
  //   }
  //   return _updateConnectionStatus(result);
  // }

  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   var checkConect = await _connectivity.checkConnectivity();

  //   if (checkConect.index != 2) {
  //     _conectadoRede = true;
  //   } else {
  //     _conectadoRede = false;
  //   }

  //   setState(() {});
  // }

  var _login = TextEditingController();
  var _senha = TextEditingController();
  var _cpfRecuperar = TextEditingController();
  bool _gpsAtivo = false;
  String _msgErroGps = "";
  bool _logando = true;
  bool _passwordVisible = false;
  bool _callCircular = false;
  bool _esqueciSenha = false;
  final focusNode = FocusNode();
  bool _conectadoRede = true;
  bool circularButtonRecuperarSenha = false;
  var _cpfRecuperarSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (_logando) {
      return _buildPreparacao();
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  // child: Container(
                  //   width: 200,
                  //   height: 150,
                  //   child: Image.asset('asset/images/logo.png'),
                  // ),
                  child: _buildLogo(),
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _login,
                  textInputAction: TextInputAction.next, // Moves focus to next.
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
                    logar(this._login.text, this._senha.text, context);
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
                          //FocusScope.of(context).unfocus();
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
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                      ),
                    ),
                    isDismissible: false,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return bottomSheetMenuRecuperarSenha(setState);
                      });
                    },
                  );
                },
                child: Text(
                  'Esqueci minha senha',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
              _buildBtnLogar(context),
              _buildInformacaoNetWork(),
              _buildInformacaoGps(),
              SizedBox(
                height: 50,
              ),
              //_buildBtnNovoUsuario(context)
            ],
          ),
        ),
      );
    }
  }

  GestureDetector _buildBtnNovoUsuario(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => AcessoInicialPage()));
      },
      child: Text(
        'Novo usuário? Criar conta',
      ),
    );
  }

  Container _buildBtnLogar(BuildContext context) {
    return Container(
      height: 50,
      width: 250,
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(20)),
      child: FlatButton(
        onPressed: () {
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
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'IN',
              style: TextStyle(
                  color: Colors.red, fontSize: 70, fontWeight: FontWeight.bold),
            ),
            Text(
              'tegra',
              style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Text(
            'MOBILE',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
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
      if (await _verificarCampos(login, senha, context)) {
        setState(() {
          _callCircular = true;
        });

        final response = await http.post(
          Uri.parse('${baseUrl}Login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              <String, String>{'Cpf': login, 'Senha': senha, 'Token': token}),
        );

        if (response.statusCode == 200 || response.statusCode == 204) {
          if (response.body != "") {
            Map<String, dynamic> userMap = jsonDecode(response.body);

            Usuario user = new Usuario();
            user = Usuario.fromJson(userMap);

            if (user.status == 0) {
              showAlertDialog(context,
                  "Seu usuário esta bloqueado, procure a administração.");
              setState(() {
                _callCircular = false;
                _logando = false;
              });
            } else {
              _saveUserLocalStore(response.body);

              if (user.primeiroAcesso == 0) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => IndexPage()));
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => AcessoInicialPage()));
              }
            }
          } else {
            showAlertDialog(context, "Usuário e/o senha inválidos.");
            setState(() {
              _callCircular = false;
            });
          }
        } else {
          showAlertDialog(context,
              "Oppssss. Parece que nossos servidores não estão respondendo bem.");
        }
      }
    } catch (e) {
      print(e);
      showAlertDialog(context,
          "Oppssss. Parece que nossos servidores não estão respondendo bem.");
      setState(() {
        _callCircular = false;
      });
    }
  }

  Future<bool> _verificarCampos(
      String login, String senha, BuildContext context) async {
    if (login.isEmpty || senha.isEmpty) {
      showAlertDialog(context, "INSIRA UM LOGIN E/OU SENHA");
      //return false;
      return Future<bool>.value(false);
    }

    // _determinePosition();
    // if (!_gpsAtivo) {
    //   showAlertDialog(context, _msgErroGps);
    //   await Future.delayed(Duration(milliseconds: 2000));
    //   //return false;
    // }

    //return true;
    return Future<bool>.value(true);
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
              controller: _cpfRecuperarSenha,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CPF',
                  hintText: 'Entre com seu cpf'))),
    );
  }

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map<String, dynamic> userMap = jsonDecode(prefs.getString('userJson'));
      Usuario user = new Usuario();
      user = Usuario.fromJson(userMap);

      if (user != null) {
        await verifcarUsuarioLogado(user.cpf, context);
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => IndexPage(),
        //   ),
        // );
      }
    } catch (e) {
      setState(() {
        _logando = false;
      });
    }
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      print(position);
      setState(() {
        _gpsAtivo = true;
      });
    }).catchError((e) {
      _gpsAtivo = false;
    });
  }

  _determinePosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _msgErroGps =
            "Sua localização esta desativada. Para que o Botão de Pânico funcione corretamente é necessário que tenhamos acesso a sua localização.";
        _gpsAtivo = false;

        showAlertDialog(context, _msgErroGps);

        return Future.error(
            'Sua localização esta desativada. Para que o Botão de Pânico funcione corretamente é necessário que tenhamos acesso a sua localização.');
      } else {
        _gpsAtivo = true;
      }

      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _msgErroGps =
              "Sua localização esta desativada. Para que o Botão de Pânico funcione corretamente é necessário que tenhamos acesso a sua localização.";
          showAlertDialog(context, _msgErroGps);
          _gpsAtivo = false;
          return Future.error(
              'Sua localização esta desativada. Para que o Botão de Pânico funcione corretamente é necessário que tenhamos acesso a sua localização.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _gpsAtivo = false;
        _msgErroGps =
            "As permissões de localização para esse app estão permanentemente desativadas. Para que o Botão de Pânico funcione corretamente é necessário que tenhamos acesso a sua localização.";
        showAlertDialog(context, _msgErroGps);
        return Future.error(
            "As permissões de localização para esse app estão permanentemente desativadas. Para que o Botão de Pânico funcione corretamente é necessário que tenhamos acesso a sua localização.");
      }

      //_gpsAtivo = true;

    } catch (e) {}
  }

  Widget _buildInformacaoNetWork() {
    if (!_conectadoRede) {
      return Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: 30,
            child: Container(
              child: Text(
                'Seu dispositivo não esta conectado a internet.',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      );
    } else
      return SizedBox.shrink();
  }

  Widget _buildInformacaoGps() {
    if (!_gpsAtivo) {
      return Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Container(
                child: Center(
                  child: Text(
                    'Para que o Botão de Pânico funcione corretamente é necessário que tenhamos acesso a sua localização.',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else
      return SizedBox.shrink();
  }

  _saveUserLocalStore(String userJson) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userJson', userJson);
  }

  Future verifcarUsuarioLogado(String login, BuildContext context) async {
    await _firebaseMessaging.getToken().then((value) {
      token = value;
    });

    try {
      final response = await http.post(
        Uri.parse('${baseUrl}Login/VerificarUsuarioLogado'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'Cpf': login, 'Token': token}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body != "") {
          Map<String, dynamic> userMap = jsonDecode(response.body);
          Usuario user = new Usuario();
          user = Usuario.fromJson(userMap);

          if (user.status == 0) {
            showAlertDialog(context,
                "Seu usuário esta bloqueado, procure a administração.");

            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            await preferences.clear();

            setState(() {
              _callCircular = false;
              _logando = false;
            });
          } else {
            _saveUserLocalStore(response.body);

            if (user.primeiroAcesso == 0) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => IndexPage()));
            } else {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AcessoInicialPage()));
            }
          }
        }
      } else {
        showAlertDialog(context,
            "Oppssss. Parece que nossos servidores não estão respondendo bem.");
        setState(() {
          _callCircular = false;
          _logando = false;
        });
      }
    } catch (e) {
      print(e);
      showAlertDialog(context,
          "Oppssss. Parece que nossos servidores não estão respondendo bem.");
      setState(() {
        _callCircular = false;
        _logando = false;
      });
    }
  }

  Widget bottomSheetMenuRecuperarSenha(StateSetter setState) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "INSIRA CPF PARA RECUPERAR SUA SENHA",
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _buildEmail(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ignore: deprecated_member_use
              FlatButton.icon(
                icon: Icon(Icons.dangerous),
                onPressed: () {
                  circularButtonRecuperarSenha = false;
                  Navigator.pop(context);
                },
                label: Text("Voltar"),
              ),
              // ignore: deprecated_member_use
              FlatButton.icon(
                icon: Icon(Icons.email),
                onPressed: () async {
                  if (_verificarCpfRecuperarSenha(
                      this._cpfRecuperarSenha.text)) {
                    circularButtonRecuperarSenha = true;
                    var teste = await enviarEmailEsqueciSenha(
                        this._cpfRecuperarSenha.text);
                  }
                  setState(() {});
                },
                label: Text("Recuperar senha"),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          if (circularButtonRecuperarSenha) CircularProgressIndicator()
        ],
      ),
    );
  }

  bool _verificarCpfRecuperarSenha(String cpf) {
    if (cpf.length != 14) {
      this.showAlertDialog(context, "CPF deve possuir 11 digitos");
      return false;
    }
    return true;
  }

  Future<bool> enviarEmailEsqueciSenha(String login) async {
    try {
      final response = await http.get(
          Uri.parse('${baseUrl}Login/recuperar_senha?cpf=' + login),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body != "") {
          Map<String, dynamic> userMap = jsonDecode(response.body);

          Usuario user = new Usuario();

          user = Usuario.fromJson(userMap);
          this.showAlertDialog(
              context, "Foi enviado um email para ${user.email}");
          circularButtonRecuperarSenha = false;
        } else {
          circularButtonRecuperarSenha = false;
          showAlertDialog(context, "CPF NÃO CADASTRADO.");
        }
        return true;
      }
    } catch (e) {
      print(e);
      showAlertDialog(context,
          "Oppssss. Parece que nossos servidores não estão respondendo bem.");
      circularButtonRecuperarSenha = false;
      return true;
    }
  }
}
