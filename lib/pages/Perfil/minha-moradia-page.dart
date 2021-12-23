import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitoria_forte/Model/SetoresLocais.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'package:vitoria_forte/Model/Usuario.dart';
import 'package:vitoria_forte/Model/moradia.dart';
import 'package:vitoria_forte/widget/textfield_widget.dart';
import '../../constants.dart';

class MinhaMoradiaPage extends StatefulWidget {
  @override
  _MinhaMoradiaPageState createState() => _MinhaMoradiaPageState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

Usuario userPage = new Usuario();
bool _callCircular = false;
SetoresLocais setorLocal = new SetoresLocais();

List<String> listRuaString = [];
List<String> listSetoresString = [];
List<String> listLocaisString = [];
List<String> listLocaisSearch = [];
List<String> listQuadraString = [];
List<String> listLoteString = [];
List<String> listLoteSearch = [];

String _setor = "";
String _local = "";
String _quadra = "";
String _lote = "";
String _rua = "";
String _numero;

Moradia moradia = new Moradia();
bool detalhes = true;

class _MinhaMoradiaPageState extends State<MinhaMoradiaPage> {
  @override
  void initState() {
    detalhes = true;
    _getUser();
    //getDetalhesMoradiaUsuario();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('MINHA RESIDÊNCIA'),
      ),
      body: detalhes ? _buildDetalhes() : _buildEditarMoradia(),
    );
  }

  Widget _buildDetalhes() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldWidget(
              label: 'SETOR:',
              text: moradia.setor,
            ),
            SizedBox(height: 24),
            TextFieldWidget(
              label: 'LOCAL:',
              text: moradia.local,
            ),
            SizedBox(height: 24),
            TextFieldWidget(
              label: 'QUADRA:',
              text: moradia.quadra,
            ),
            SizedBox(height: 24),
            TextFieldWidget(
              label: 'LOTE:',
              text: moradia.lote,
            ),
            SizedBox(height: 24),
            TextFieldWidget(label: 'RUA:', text: moradia.rua),
            SizedBox(height: 24),
            TextFieldWidget(
              label: 'Nº LOGRADOURO:',
              text: moradia.nLogradouro,
            ),
            SizedBox(height: 24),
            _buildBtnAlterar()
          ],
        ),
      ),
    );
  }

  Widget _buildEditarMoradia() {
    return Container(
      margin: EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSetores(),
              _buildLocais(),
              _buildQuadra(),
              _buildLote(),
              _buildRua(),
              _buildNumero(),
              SizedBox(height: 24),
              _buildBtnSalvar()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBtnAlterar() {
    return GestureDetector(
      onTap: () {
        detalhes = false;
        getSetoresLocais();
        setState(() {});
      },
      child: Center(
        child: Container(
          width: 100,
          height: 35,
          decoration: BoxDecoration(
              color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            'ALTERAR',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          )),
        ),
      ),
    );
  }

  Widget _buildBtnSalvar() {
    return GestureDetector(
      onTap: () {
        detalhes = false;
        if (!_formKey.currentState.validate()) {
          return;
        } else {
          _formKey.currentState.save();
          _salvarMoradia();
        }
      },
      child: Center(
        child: Container(
          width: 100,
          height: 35,
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            'SALVAR',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          )),
        ),
      ),
    );
  }

  Future getSetoresLocais() async {
    _carregando("Carregando...");

    try {
      final response = await http.get(
          Uri.parse('${baseUrl}Denuncia/listar_setores_locais'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body != "") {
          Map<String, dynamic> setoresLocaisMap = jsonDecode(response.body);

          setorLocal = SetoresLocais.fromJson(setoresLocaisMap);

          listSetoresString.clear();
          listLocaisString.clear();

          for (var _setor in setorLocal.listSetores) {
            listSetoresString.add("${_setor.id} : ${_setor.descricao}");
          }

          for (var _local in setorLocal.listLocais) {
            listLocaisString.add(
                "${_local.id} : ${_local.descricaoSetor} -> ${_local.descricao}");
          }

          for (var _quadra in setorLocal.listQuadra) {
            listQuadraString
                .add("${_quadra.id} : (Quadra ${_quadra.descricao})");
          }

          for (var _lote in setorLocal.listLote) {
            listLoteString.add(
                "${_lote.id} : (Quadra ${_lote.descricaoQuadra}) -> Lote (${_lote.descricao})");
          }

          for (var _rua in setorLocal.listRua) {
            listRuaString.add("${_rua.id} : ${_rua.descricao}");
          }

          Navigator.of(context).pop();
          setState(() {});
        } else {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      showAlertDialog(
        context,
        "Oppppsss...",
        "Parece que nossos servidores não estão respondendo bem.",
      );
    }
  }

  Future getDetalhesMoradiaUsuario() async {
    _carregando("Carregando...");

    try {
      final response = await http.get(
          Uri.parse('${baseUrl}Usuario/GetDadosMoradia?cpf=' + userPage.cpf),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body != "") {
          Map<String, dynamic> userMap = jsonDecode(response.body);

          setState(() {
            moradia = Moradia.fromJson(userMap);
          });

          Navigator.of(context).pop();
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

  Future _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> userMap = jsonDecode(prefs.getString('userJson'));
      Usuario user = new Usuario();
      user = Usuario.fromJson(userMap);
      userPage = user;
      if (detalhes) {
        await getDetalhesMoradiaUsuario();
      }
      // setState(() {
      //   userPage = user;
      // });
    } catch (e) {}
  }

  Widget _buildQuadra() {
    return DropdownSearch<String>(
        mode: Mode.DIALOG,
        showSelectedItems: true,
        dropdownSearchDecoration: InputDecoration(
          hintText: "Selecione uma Quadra",
          labelText: "Quadra",
          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
          //border: OutlineInputBorder(),
        ),
        items: listQuadraString,
        showClearButton: true,
        onChanged: (value) {
          _quadra = value;
          listLoteSearch = [];
          if (value != null) {
            var arrayId = value.split(':');
            var quadraString = arrayId[1].trim();

            listLoteSearch = listLoteString
                .where((element) => element.contains(quadraString))
                .toList();
          } else {
            listLocaisSearch = [];
          }
          setState(() {});
        },
        validator: (String value) {
          if (value == null) {
            return 'campo obrigatório';
          }
        });
  }

  Widget _buildLote() {
    return DropdownSearch<String>(
        mode: Mode.DIALOG,
        showSelectedItems: true,
        dropdownSearchDecoration: InputDecoration(
          hintText: "Selecione um Lote",
          labelText: "Lote",
          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
          //border: OutlineInputBorder(),
        ),
        items: listLoteSearch,
        showClearButton: true,
        onChanged: (value) {
          _lote = value;
        },
        validator: (String value) {
          if (value == null) {
            return 'campo obrigatório';
          }
        });
  }

  Widget _buildRua() {
    return DropdownSearch<String>(
      mode: Mode.DIALOG,
      showSelectedItems: true,
      dropdownSearchDecoration: InputDecoration(
        hintText: "Selecione uma rua",
        labelText: "Rua",
        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
        //border: OutlineInputBorder(),
      ),
      items: listRuaString,
      showClearButton: true,
      onChanged: (value) {
        _rua = value;
      },
    );
  }

  Widget _buildSetores() {
    return DropdownSearch<String>(
        mode: Mode.DIALOG,
        showSelectedItems: true,
        dropdownSearchDecoration: InputDecoration(
          hintText: "Selecione um setor",
          labelText: "Setor",
          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
          //border: OutlineInputBorder(),
        ),
        items: listSetoresString,
        showClearButton: true,
        onChanged: (value) {
          _setor = value;
          listLocaisSearch = [];
          if (value != null) {
            var arrayId = value.split(':');
            var setorString = arrayId[1].trim();

            listLocaisSearch = listLocaisString
                .where((element) => element.contains(setorString))
                .toList();
          } else {
            listLocaisSearch = [];
          }
          setState(() {});
        },
        validator: (String value) {
          if (value == null) {
            return 'campo obrigatório';
          }
        });
  }

  Widget _buildLocais() {
    return DropdownSearch<String>(
      mode: Mode.DIALOG,
      showSelectedItems: true,
      dropdownSearchDecoration: InputDecoration(
        hintText: "Selecione um local",
        labelText: "Local",
        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
        //border: OutlineInputBorder(),
      ),
      items: listLocaisSearch,
      showClearButton: true,
      onChanged: (value) {
        _local = value;
      },
    );
  }

  Widget _buildNumero() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'N° Apartamento/Casa',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'campo obrigatório';
        }
      },
      onSaved: (String value) {
        _numero = value;
      },
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

  _salvarMoradia() async {
    _carregando("Salvando...");
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}Usuario/AlterarMoradiaMorador'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Cpf': userPage.cpf,
          'Setor': _setor,
          'Local': _local,
          'Quadra': _quadra,
          'Lote': _lote,
          'NApartamentoCasa': _numero,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        Navigator.of(context).pop();
        if (response.body == "1") {
          showAlertDialog(
            context,
            "Parabéns",
            "Atualização realizada com sucesso.",
          );
        } else {
          showAlertDialog(
            context,
            "OPSSS...",
            "Parece que algo deu errado.",
          );
        }
      } else {
        Navigator.of(context).pop();
        showAlertDialog(
          context,
          "Oppsss",
          "Parece que nossos servidores não estão respondendo como esperado, tente novamente mais tarde.",
        );
      }
    } catch (e) {
      showAlertDialog(
        context,
        "Oppsss",
        "Não conseguimos enviar seus dados de primeiro acesso, tente novamente.",
      );
    }
  }
}
