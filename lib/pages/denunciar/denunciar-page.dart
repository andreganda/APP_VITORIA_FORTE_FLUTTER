import 'package:flutter/material.dart';
import 'package:vitoria_forte/widget/menu-widget.dart';

class DenunciarPage extends StatefulWidget {
  @override
  _DenunciarPageState createState() => _DenunciarPageState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

String _descricaoFato;
bool _callCircular = false;
bool _lights = false;
String textDenuncia = "ESSA DENÚNCIA NÃO SERA ANÔNIMA";
Color corText = Colors.black;

class _DenunciarPageState extends State<DenunciarPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Gerar Denuncia"),
          leading: MenuWidget(),
        ),
        body: _buildContainer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (!_formKey.currentState.validate()) {
              setState(() {
                _callCircular = false;
              });
              return;
            } else {
              _formKey.currentState.save();
              setState(() {
                _callCircular = true;
              });
            }
          },
          child: Icon(Icons.send),
          tooltip: 'Enviar Relatório',
          backgroundColor: Colors.green,
        ),
      ),
    );
  }

  Widget _buildDescricao() {
    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(
          labelText: 'Descrição Fato',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0))),
      validator: (String value) {
        if (value.isEmpty) {
          return 'campo obrigatório';
        }
      },
      onSaved: (String value) {
        _descricaoFato = value;
      },
    );
  }

  Widget _buildTipoDenuncia() {
    var switchListTile = SwitchListTile(
      title: Text(
        'DENÚNCIA ANÔNIMA?',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      value: _lights,
      onChanged: (bool value) {
        setState(() {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }

          _lights = value;
          if (!value) {
            textDenuncia = "ESSA DENÚNCIA NÃO SERA ANÔNIMA";
            corText = Colors.black;
          } else {
            textDenuncia = "ESSA DENÚNCIA SERA ANÔNIMA";
            corText = Colors.red;
          }
          _buildTextTipoDenuncia(textDenuncia, corText);
        });
      },
      secondary: Transform.scale(
        scale: 2.0,
        child: Icon(
          // Based on passwordVisible state choose the icon
          !_lights ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).primaryColorDark,
        ),
      ),
    );
    return switchListTile;
  }

  Widget _buildTextTipoDenuncia(String text, Color color) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Container _buildContainer() {
    return Container(
      margin: EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTipoDenuncia(),
              SizedBox(
                height: 10,
              ),
              _buildDescricao(),
              SizedBox(
                height: 30,
              ),
              if (_callCircular) CircularProgressIndicator(),
              _buildTextTipoDenuncia(textDenuncia, corText)
            ],
          ),
        ),
      ),
    );
  }
}
