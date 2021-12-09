import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitoria_forte/Model/Usuario.dart';
import 'package:vitoria_forte/Model/Veiculo.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class VeiculosPage extends StatefulWidget {
  @override
  _VeiculosPageState createState() => _VeiculosPageState();
}

Usuario userPage = new Usuario();
var _placaController = TextEditingController();
var _modeloController = TextEditingController();
List<Veiculo> veiculos = <Veiculo>[];

class _VeiculosPageState extends State<VeiculosPage> {
  @override
  void initState() {
    _getUser();
    //_getVeiculos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'MEUS VEÍCULOS',
          ),
          actions: [],
        ),
        body: Container(
          margin: EdgeInsets.all(15),
          child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildVeiculos(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildListViewVeiculos(),
                ],
              )),
        ));
  }

  Widget _buildVeiculos() {
    return Container(
      child: new Row(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              controller: _placaController,
              decoration: InputDecoration(
                labelText: 'Placa',
                border: UnderlineInputBorder(),
              ),
            ),
          ),
          Flexible(
            child: TextFormField(
              controller: _modeloController,
              decoration: InputDecoration(
                labelText: 'Modelo',
                border: UnderlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.save_sharp),
            color: Colors.green,
            tooltip: 'Incluir veículo',
            onPressed: () {
              _salvarVeiculo(_placaController.text, _modeloController.text);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListViewVeiculos() {
    return SizedBox(
      // height: 100,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: veiculos.length,
        itemBuilder: (context, index) {
          var placa = veiculos[index].placa;
          var modelo = veiculos[index].modelo;
          var idVeiculo = veiculos[index].id;
          return Card(
            child: ListTile(
              title: Text("PLACA: ${placa}"),
              subtitle: Text("Modelo: ${modelo}"),
              leading: Icon(
                Icons.car_repair,
                size: MediaQuery.of(context).size.height * 0.04,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      size: 25.0,
                      color: Colors.brown[900],
                    ),
                    onPressed: () {
                      confirmacaoShowAlertDialog(
                          context,
                          "Atenção",
                          "Tem certeza que deseja excluir esse veículo?",
                          index,
                          idVeiculo);
                      //veiculos.removeAt(index);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> userMap = jsonDecode(prefs.getString('userJson'));
      Usuario user = new Usuario();
      userPage = Usuario.fromJson(userMap);
      _getVeiculos();
    } catch (e) {}
  }

  Future _getVeiculos() async {
    try {
      final response = await http.get(
          Uri.parse('${baseUrl}Usuario/GetVeiculosMorador?cpf=' + userPage.cpf),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body != "") {
          Iterable decoded = jsonDecode(response.body);
          veiculos = decoded.map((data) => Veiculo.fromJson(data)).toList();

          setState(() {});
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future _removerVeiculo(int idVeiculo, int index) async {
    try {
      final response = await http.get(
          Uri.parse(
              '${baseUrl}Usuario/DeleteVeiculosMorador?cpf=${userPage.cpf}&idVeiculo=${idVeiculo}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body == "1") {
          veiculos.removeAt(index);
          Navigator.of(context).pop();
          setState(() {});
        }
      }
    } catch (e) {
      print(e);
    }
  }

  confirmacaoShowAlertDialog(BuildContext context, String title, String text,
      int index, int idVeiculo) {
    Widget naoButton = FlatButton(
      child: Text("Não"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget simButton = FlatButton(
      child: Text("Sim"),
      onPressed: () {
        Navigator.of(context).pop();
        _removerVeiculo(idVeiculo, index);
        _carregando("Excluindo veículo");
      },
    );

    AlertDialog alerta = AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [naoButton, simButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }

  mensagemInformacaoShowAlertDialog(
      BuildContext context, String title, String text) {
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

  _salvarVeiculo(String placa, String modelo) async {
    //abrindo loading
    _carregando("Salvando veículo");

    try {
      final response = await http.post(
        Uri.parse('${baseUrl}Usuario/SalvarVeiculoMorador'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'placa': placa,
          'modelo': modelo,
          'userCpf': userPage.cpf
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        Navigator.of(context).pop();
        if (response.body != "0") {
          Veiculo veiculo = Veiculo(
              id: int.parse(response.body), placa: placa, modelo: modelo);
          veiculos.add(veiculo);

          _placaController.text = "";
          _modeloController.text = "";
          FocusScope.of(context).requestFocus(FocusNode());

          setState(() {});
          mensagemInformacaoShowAlertDialog(
            context,
            "Parabéns",
            "Sua veículo foi salvo com sucesso",
          );
        }
      }

      Navigator.of(context).pop();
    } catch (e) {
      Navigator.of(context).pop();
      mensagemInformacaoShowAlertDialog(
        context,
        "Oppsss",
        "Não conseguimos salvar seu veículo, tente novamente.",
      );
    }
  }
}
