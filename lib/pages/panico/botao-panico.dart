import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitoria_forte/Model/Usuario.dart';
import 'package:vitoria_forte/widget/menu-widget.dart';
import 'package:signalr_client/signalr_client.dart';

class PanicoPage extends StatefulWidget {
  @override
  _PanicoPageState createState() => _PanicoPageState();
}

class _PanicoPageState extends State<PanicoPage> {
  final hubConnection = HubConnectionBuilder()
      .withUrl("http://vitoriaforte.web22f41.kinghost.net/chatHub")
      .build();

  final List<String> messages = new List<String>();

  @override
  void initState() {
    super.initState();
    _getUser();
    hubConnection.onclose((_) {
      print("Conexão perdida");
      startConnection();
    });

    hubConnection.on("ReceiveMessage", onReceiveMessage);

    startConnection();
  }

  void startConnection() async {
    await hubConnection.start(); // Inicia a conexão ao servidor
  }

  int _counter = 0;
  String _msg = "";
  bool _pedidoEnviado = false;
  bool _buttonPressed = false;
  bool _loopActive = false;
  bool _isPressed = false;
  Usuario userPage = new Usuario();

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

  void onReceiveMessage(List<Object> result) {
    setState(() {
      messages.add("${result[0]} diz: ${result[1]}");
    });
  }

  void sendMessage() async {
    await hubConnection.invoke("SendMessage", args: <Object>[
      this.userPage.nome.toString(),
      "Flutter"
    ]).catchError((err) {
      print(err);
    });
  }

  void _increaseCounterWhilePressed() async {
    if (_loopActive) return;
    _loopActive = true;
    while (_buttonPressed) {
      setState(() {
        _counter++;
        _msg = _counter.toString();
      });

      if (_counter == 5) {
        _pedidoEnviado = true;
        _loopActive = false;
        _msg = _counter.toString();
        sendMessage();
        _counter = 0;
      }
      await Future.delayed(Duration(milliseconds: 1000));
    }
    _loopActive = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Botão do pânico"),
          backgroundColor: Colors.red,
          leading: MenuWidget(),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    'PRESSIONE O BOTÃO POR 5 SEGUNDOS PARA PEDIR SOCORRO.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Listener(
                  onPointerDown: (details) {
                    _buttonPressed = true;
                    _increaseCounterWhilePressed();
                  },
                  onPointerUp: (details) {
                    _buttonPressed = false;
                    setState(() {
                      _counter = 0;
                      _msg = _counter.toString();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(0.0),
                    width: 250.0,
                    height: 250.0,
                    decoration: new BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _msg,
                        style: TextStyle(
                            fontSize: 150, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                _pedidoEnviado
                    ? Center(
                        child: Text(
                          'PEDIDO DE SOCORRO ENVIADO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      )
                    : SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
