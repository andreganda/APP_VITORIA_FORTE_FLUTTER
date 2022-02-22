import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitoria_forte/Model/Usuario.dart';
import 'package:vitoria_forte/Model/aviso.dart';
import 'package:vitoria_forte/Model/notification.dart';
import 'package:vitoria_forte/Services/user-service.dart';
import 'package:vitoria_forte/pages/avisos/avisos-detalhes-page.dart';
import 'package:vitoria_forte/widget/menu-widget.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';

class AvisosPage extends StatefulWidget {
  @override
  _AvisosPageState createState() => _AvisosPageState();
}

Usuario userPage = new Usuario();
List<Aviso> listaAvisos = <Aviso>[];
UserService userService = UserService();

class _AvisosPageState extends State<AvisosPage> {
  @override
  void initState() {
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    _getUser();
    super.initState();
  }

  _changeBody(String msg) {
    setState(() {
      //notificationBody = msg;
      showAlertDialog(context, "Nova Notificação", msg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'AVISOS / NOTIFICAÇÕES',
        ),
        leading: MenuWidget(),
      ),
      body: RefreshIndicator(
        onRefresh: _getListNotificacao,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: listaAvisos.length,
            itemBuilder: (context, index) {
              var aviso = listaAvisos[index];
              return GestureDetector(
                onTap: () async {
                  await userService.SetarNotificacaoComoLida(
                          aviso.id, userPage.cpf)
                      .then((value) {
                    aviso.statusUserLido = 1;
                    listaAvisos[index] = aviso;
                    setState(() {});
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AvisosDetalhesPage(
                          avisoParam: aviso,
                        ),
                      ),
                    );
                  });
                  //
                },
                child: Card(
                  child: ListTile(
                    title: _builTitle(
                      aviso.titulo.toUpperCase(),
                    ),
                    subtitle: aviso.statusUserLido == 1
                        ? _builSubTitle("Enviado em: " + aviso.dataFormat)
                        : _builSubTitleNaoLido(
                            "Enviado em: " + aviso.dataFormat + " - NÃO LIDO"),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String title, String text) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alerta = AlertDialog(
      title: Text(title),
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

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> userMap = jsonDecode(prefs.getString('userJson'));
      Usuario user = new Usuario();
      userPage = Usuario.fromJson(userMap);
      _getListNotificacao();
    } catch (e) {}
  }

  Future _getListNotificacao() async {
    _carregando("Carregando...");
    try {
      final response = await http.get(
          Uri.parse(
              '${baseUrl}Notificacao/listar_notificacoes?cpf=' + userPage.cpf),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body != "") {
          Iterable decoded = jsonDecode(response.body);
          listaAvisos = decoded.map((data) => Aviso.fromJson(data)).toList();
          Navigator.of(context).pop();
          setState(() {});
        }
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      Navigator.of(context).pop();
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
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
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
}

Widget _builTitle(titulo) {
  return Text(
    titulo,
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget _builSubTitle(titulo) {
  return Text(
    titulo,
    style: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget _builSubTitleNaoLido(titulo) {
  return Text(
    titulo,
    style: TextStyle(
      fontSize: 13,
      color: Colors.red,
      fontWeight: FontWeight.bold,
    ),
  );
}
