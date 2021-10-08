import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vitoria_forte/widget/menu-widget.dart';

class DenunciarPage extends StatefulWidget {
  @override
  _DenunciarPageState createState() => _DenunciarPageState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

String _descricaoFato;
bool _callCircular = false;
bool _lights = true;
String textDenuncia = "ESSA DENÚNCIA SERA ANÔNIMA";
Color corText = Colors.red;
var listFotos = new List<FileImage>();
int photoEscolhida = -1;

final ImagePicker _picker = ImagePicker();

class _DenunciarPageState extends State<DenunciarPage> {
  @override
  void dispose() {
    listFotos = new List<FileImage>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        photoEscolhida = -1;
        setState(() {});
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

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Escolha um lugar",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            // ignore: deprecated_member_use
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            // ignore: deprecated_member_use
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Galeria"),
            ),
          ])
        ],
      ),
    );
  }

  Widget bottomSheetMenuExcluir(int indice) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Deseja excluir essa foto?",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            // ignore: deprecated_member_use
            FlatButton.icon(
              icon: Icon(Icons.dangerous),
              onPressed: () {
                setState(() {
                  photoEscolhida = -1;
                });
                Navigator.pop(context);
              },
              label: Text("Não"),
            ),
            // ignore: deprecated_member_use
            FlatButton.icon(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                setState(() {
                  listFotos.removeAt(indice);
                  Navigator.pop(context);
                });
              },
              label: Text("Sim"),
            ),
          ])
        ],
      ),
    );
  }

  Widget _buildBtnAddFotos() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: ((builder) => bottomSheet()),
        );
      },
      child: Container(
        alignment: Alignment.bottomLeft,
        child: Container(
          width: 100,
          height: 35,
          decoration: BoxDecoration(
              color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            'INCLUIR FOTO',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          )),
        ),
      ),
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
              SizedBox(
                height: 10,
              ),
              _buildDescricao(),
              SizedBox(
                height: 10,
              ),
              _buildBtnAddFotos(),
              SizedBox(
                height: 30,
              ),
              if (_callCircular) CircularProgressIndicator(),
              _buildTextTipoDenuncia(textDenuncia, corText),
              SizedBox(
                height: 30,
              ),
              _buildGridFotos()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridFotos() {
    return GridView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: listFotos.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              isDismissible: false,
              context: context,
              builder: ((builder) => bottomSheetMenuExcluir(index)),
            );
            setState(() {
              photoEscolhida = index;
            });
          },
          child: index == photoEscolhida
              ? Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: DecorationImage(
                      image: listFotos[index],
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(
                      color: Colors.green,
                      width: 10.0,
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: DecorationImage(
                      image: listFotos[index],
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(color: Colors.green),
                  ),
                ),
        );
      },
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );

    if (pickedFile != null) {
      print('tirou foto');
      var file = File(pickedFile.path);
      var fileImage = FileImage(file);
      listFotos.add(fileImage);
      Navigator.pop(context);
      photoEscolhida = -1;
      setState(() {});
    }
  }
}
