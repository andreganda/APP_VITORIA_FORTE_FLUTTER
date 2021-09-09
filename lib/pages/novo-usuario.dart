import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class NovoUsuarioPage extends StatefulWidget {
  @override
  _NovoUsuarioPageState createState() => _NovoUsuarioPageState();
}

class _NovoUsuarioPageState extends State<NovoUsuarioPage> {
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
  bool _callCircular = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Cadastro de usuário'),
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCpf(),
                _buildEmail(),
                _buildNome(),
                _buildTelefone(),
                _buildDatanascimento(),
                _buildNumero(),
                _buildSenha(),
                _buildConfirmar(),
                SizedBox(
                  height: 30,
                ),
                if (_callCircular) CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_formKey.currentState.validate()) {
            return;
          } else {
            _formKey.currentState.save();
            print(_cpf);

            setState(() {
              _callCircular = true;
            });
          }
        },
        child: const Icon(Icons.send),
        tooltip: 'Enviar Relatório',
        backgroundColor: Colors.green,
      ),
    );
  }
}
