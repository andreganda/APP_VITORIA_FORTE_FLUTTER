import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vitoria_forte/Model/aviso.dart';
import 'package:vitoria_forte/widget/textfield_widget.dart';

class AvisosDetalhesPage extends StatefulWidget {
  final Aviso avisoParam;

  const AvisosDetalhesPage({
    Key key,
    @required this.avisoParam,
  }) : super(key: key);

  @override
  _AvisosDetalhesPageState createState() => _AvisosDetalhesPageState();
}

class _AvisosDetalhesPageState extends State<AvisosDetalhesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('DETALHES DA NOTIFICAÇÃO'),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldWidget(
                  label: 'Enviado em:', text: widget.avisoParam.dataFormat),
              SizedBox(height: 20),
              TextFieldWidget(
                label: 'Título:',
                text: widget.avisoParam.titulo,
              ),
              SizedBox(height: 20),
              TextFieldWidget(
                label: 'Mensagem:',
                text: widget.avisoParam.mensagem,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
