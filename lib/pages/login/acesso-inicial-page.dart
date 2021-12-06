import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitoria_forte/Model/SetoresLocais.dart';
import 'package:vitoria_forte/Model/Usuario.dart';
import 'package:vitoria_forte/Model/Veiculo.dart';

import '../../constants.dart';

class AcessoInicialPage extends StatefulWidget {
  @override
  _AcessoInicialPageState createState() => _AcessoInicialPageState();
}

class _AcessoInicialPageState extends State<AcessoInicialPage> {
  @override
  void initState() {
    _getUser();
    getSetoresLocais();
    super.initState();
  }

  Usuario userPage = new Usuario();
  String _cpf;
  String _nome;
  String _dataNascimento;
  String _telefone;

  String _email;
  String _cep;
  String _logradouro;
  String _numero;
  String _uf;
  String _bairro;
  String _cidade;
  String _complemento;
  String _senha;
  String _confirmarSenha;

  //CONTATO EMERGENCIA
  String _nomeContatoEmergencia;
  String _telefoneEmergencia;

  var _placaController = TextEditingController();
  var _modeloController = TextEditingController();

  var veiculos = <Veiculo>[];

  bool _callCircular = false;
  SetoresLocais setorLocal = new SetoresLocais();
  List<String> listSetoresString = [];
  List<DropdownMenuItem> listLocais = [];
  List<String> listLocaisString = [];
  List<String> listLocaisSearch = [];
  String _setor = "";
  String _local = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildButtonEnviar() {
    return FlatButton(
      color: Colors.blue,
      textColor: Colors.white,
      child: Text('Enviar Dados'),
      onPressed: () {
        if (!_formKey.currentState.validate()) {
          return;
        } else {
          _formKey.currentState.save();
          _salvarDadosPrimeiroAcesso();
          setState(() {
            _callCircular = true;
          });
        }
      },
    );
  }

  Widget _buildCpf() {
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CpfInputFormatter(),
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'CPF',
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

  Widget _buildNome() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Nome',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'campo obrigatório';
        }
      },
      onSaved: (String value) {
        _nome = value;
      },
    );
  }

  Widget _buildNomeContatoEmergencia() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Nome',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'campo obrigatório';
        }
      },
      onSaved: (String value) {
        _nomeContatoEmergencia = value;
      },
    );
  }

  Widget _buildDatanascimento() {
    return TextFormField(
      inputFormatters: [
        // obrigatório
        FilteringTextInputFormatter.digitsOnly,
        DataInputFormatter(),
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Data Nascimento',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'campo obrigatório';
        }
      },
      onSaved: (String value) {
        _dataNascimento = value;
      },
    );
  }

  Widget _buildTelefone() {
    return TextFormField(
      inputFormatters: [
        // obrigatório
        FilteringTextInputFormatter.digitsOnly,
        TelefoneInputFormatter(),
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Telefone',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'campo obrigatório';
        }
      },
      onSaved: (String value) {
        _telefone = value;
      },
    );
  }

  Widget _buildTelefoneEmergencia() {
    return TextFormField(
      inputFormatters: [
        // obrigatório
        FilteringTextInputFormatter.digitsOnly,
        TelefoneInputFormatter(),
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Telefone',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'campo obrigatório';
        }
      },
      onSaved: (String value) {
        _telefoneEmergencia = value;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'campo obrigatório';
        }
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _buildCep() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'CEP',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'campo obrigatório';
        }
      },
      onSaved: (String value) {
        _cep = value;
      },
    );
  }

  Widget _buildLogradouro() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Logradouro',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'campo obrigatório';
        }
      },
      onSaved: (String value) {
        _logradouro = value;
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

  Widget _buildUf() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'UF',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'campo obrigatório';
        }
      },
      onSaved: (String value) {
        _uf = value;
      },
    );
  }

  Widget _buildBairro() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Bairro',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'campo obrigatório';
        }
      },
      onSaved: (String value) {
        _bairro = value;
      },
    );
  }

  Widget _buildCidade() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Cidade',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'campo obrigatório';
        }
      },
      onSaved: (String value) {
        _cidade = value;
      },
    );
  }

  Widget _buildComplemento() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Complemento',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'campo obrigatório';
        }
      },
      onSaved: (String value) {
        _complemento = value;
      },
    );
  }

  Widget _buildSenha() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Senha',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'campo obrigatório';
        }
      },
      onSaved: (String value) {
        _senha = value;
      },
    );
  }

  Widget _buildConfirmar() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirmar senha',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'campo obrigatório';
        }
      },
      onSaved: (String value) {
        _confirmarSenha = value;
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
      validator: (String value) {
        if (value == null) {
          return 'campo obrigatório';
        }
      },
    );
  }

  Widget _buildLabelMeusDados() {
    return Text(
      '- DADOS PESSOAIS -',
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      '- ${label} -',
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
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
              ),
            ),
          ),
          Flexible(
            child: TextFormField(
              controller: _modeloController,
              decoration: InputDecoration(
                labelText: 'Modelo',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.save_sharp),
            color: Colors.green,
            tooltip: 'Incluir veículo',
            onPressed: () {
              Veiculo veiculo = Veiculo(
                  Placa: _placaController.text, Modelo: _modeloController.text);
              veiculos.add(veiculo);

              _placaController.text = "";
              _modeloController.text = "";
              FocusScope.of(context).requestFocus(FocusNode());

              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListViewVeiculos() {
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: veiculos.length,
        itemBuilder: (context, index) {
          var placa = veiculos[index].Placa;
          var modelo = veiculos[index].Modelo;

          return ListTile(
            leading: Icon(Icons.car_repair),
            title: Text(placa),
            subtitle: Text(modelo),
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
                    veiculos.removeAt(index);
                    setState(() {});
                  },
                ),
              ],
            ),
            //isThreeLine: true,
          );
        },
      ),
    );
  }

  Future getSetoresLocais() async {
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
        }
      }
    } catch (e) {}
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

  _salvarDadosPrimeiroAcesso() async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}Login/SalvarDadosPrimeiroAcesso'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Cpf': userPage.cpf,
          'Setor': _setor,
          'Local': _local,
          'DataNascimento': _dataNascimento,
          'NApartamentoCasa': _numero,
          'Telefone': _telefone,
          'NomeContatoEmergencia': _nomeContatoEmergencia,
          'TelefoneContatoEmergencia': _telefoneEmergencia,
          'Veiculos': jsonEncode(veiculos),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        showAlertDialog(
          context,
          "Parabéns",
          "Sua denuncia foi enviada com sucesso",
        );

        setState(() {
          _callCircular = false;
        });
      } else {
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
      setState(() {
        _callCircular = false;
      });
    }
  }

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> userMap = jsonDecode(prefs.getString('userJson'));
      Usuario user = new Usuario();
      user = Usuario.fromJson(userMap);
      setState(() {
        userPage = user;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Primeiro acesso'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLabel('DADOS PESSOAIS'),
                  _buildSetores(),
                  _buildLocais(),
                  _buildDatanascimento(),
                  _buildNumero(),
                  _buildTelefone(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  _buildLabel('CONTATO DE EMERGÊNCIA'),
                  _buildNomeContatoEmergencia(),
                  _buildTelefoneEmergencia(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  _buildLabel('CADASTRE SEU(S) VEÍCULO(S)'),
                  SizedBox(
                    height: 10,
                  ),
                  _buildVeiculos(),
                  _buildListViewVeiculos(),
                  //_buildSenha(),
                  //_buildConfirmar(),

                  if (_callCircular) CircularProgressIndicator(),
                  SizedBox(height: 10),
                  _buildButtonEnviar(),
                ],
              ),
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (!_formKey.currentState.validate()) {
      //       return;
      //     } else {
      //       _formKey.currentState.save();
      //       print(_cpf);

      //       setState(() {
      //         _callCircular = true;
      //       });
      //     }
      //   },
      //   child: const Icon(Icons.send),
      //   tooltip: 'Enviar Relatório',
      //   backgroundColor: Colors.green,
      // ),
    );
  }
}
