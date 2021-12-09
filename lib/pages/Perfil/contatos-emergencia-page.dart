import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vitoria_forte/Model/ContatoEmergencia.dart';
import 'package:vitoria_forte/Model/Usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitoria_forte/constants.dart';

class ContatosEmergenciaPage extends StatefulWidget {
  @override
  _ContatosEmergenciaPageState createState() => _ContatosEmergenciaPageState();
}

Usuario userPage = new Usuario();
var _nomeController = TextEditingController();
var _telefoneController = TextEditingController();
List<ContatoEmergencia> listContatosEmergencia = <ContatoEmergencia>[];

class _ContatosEmergenciaPageState extends State<ContatosEmergenciaPage> {
  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'MEUS CONTATOS',
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
                  _buildForms(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildListViewContatos(),
                ],
              )),
        ));
  }

  Widget _buildForms() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 9,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: UnderlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: _telefoneController,
                inputFormatters: [
                  // obrigatório
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter(),
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  border: UnderlineInputBorder(),
                ),
              ),
              // IconButton(
              //   icon: const Icon(Icons.save_sharp),
              //   color: Colors.green,
              //   tooltip: 'Incluir contato',
              //   onPressed: () {
              //     _salvarContatoEmergencia(
              //         _nomeController.text, _telefoneController.text);
              //   },
              // ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Icon(
              Icons.save_sharp,
              size: MediaQuery.of(context).size.height * 0.05,
            ),
            color: Colors.green,
            tooltip: 'Incluir contato',
            onPressed: () {
              _salvarContatoEmergencia(
                  _nomeController.text, _telefoneController.text);
            },
          ),
        )
      ],
    );
  }

  Widget _buildListViewContatos() {
    return SizedBox(
      // height: 100,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: listContatosEmergencia.length,
        itemBuilder: (context, index) {
          var nomeContato = listContatosEmergencia[index].nome;
          var telefoneContato = listContatosEmergencia[index].telefone;
          var idContato = listContatosEmergencia[index].id;
          return Card(
            child: ListTile(
              title: Text("${nomeContato}"),
              subtitle: Text("${telefoneContato}"),
              leading: Icon(
                Icons.person,
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
                          "Tem certeza que deseja excluir esse contato?",
                          index,
                          idContato);
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
      _getContatosEmergencia();
    } catch (e) {}
  }

  Future _getContatosEmergencia() async {
    try {
      final response = await http.get(
          Uri.parse('${baseUrl}Usuario/GetContatosEmergenciaMorador?cpf=' +
              userPage.cpf),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body != "") {
          Iterable decoded = jsonDecode(response.body);
          listContatosEmergencia =
              decoded.map((data) => ContatoEmergencia.fromJson(data)).toList();

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
              '${baseUrl}Usuario/DeleteContatosEmergenciaMorador?cpf=${userPage.cpf}&idContatoEmergencia=${idVeiculo}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body == "1") {
          listContatosEmergencia.removeAt(index);
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
        _carregando("Excluindo contato");
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

  _salvarContatoEmergencia(String nomeContato, String telefoneContato) async {
    //abrindo loading
    _carregando("Salvando contato");

    try {
      final response = await http.post(
        Uri.parse('${baseUrl}Usuario/SalvarContatoEmergencia'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'nome': nomeContato,
          'telefone': telefoneContato,
          'userCpf': userPage.cpf
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        Navigator.of(context).pop();
        if (response.body != "0") {
          ContatoEmergencia veiculo = ContatoEmergencia(
              id: int.parse(response.body),
              nome: nomeContato,
              telefone: telefoneContato);
          listContatosEmergencia.add(veiculo);

          _nomeController.text = "";
          _telefoneController.text = "";
          FocusScope.of(context).requestFocus(FocusNode());

          setState(() {});
          mensagemInformacaoShowAlertDialog(
            context,
            "Parabéns",
            "Sua contato foi salvo com sucesso",
          );
        }
      }

      Navigator.of(context).pop();
    } catch (e) {
      Navigator.of(context).pop();
      mensagemInformacaoShowAlertDialog(
        context,
        "Oppsss",
        "Não conseguimos salvar seu contato, tente novamente.",
      );
    }
  }
}
