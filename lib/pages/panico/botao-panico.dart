import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:vitoria_forte/widget/menu-widget.dart';

class PanicoPage extends StatefulWidget {
  @override
  _PanicoPageState createState() => _PanicoPageState();
}

class _PanicoPageState extends State<PanicoPage> {
  int _counter = 0;
  String _msg = "";
  bool _pedidoEnviado = false;
  bool _buttonPressed = false;
  bool _loopActive = false;
  bool _isPressed = false;

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
