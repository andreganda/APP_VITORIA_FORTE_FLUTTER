import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitoria_forte/Model/ContatoEmergencia.dart';
import 'package:vitoria_forte/Model/Usuario.dart';
import 'package:vitoria_forte/pages/Perfil/contatos-emergencia-page.dart';
import 'package:vitoria_forte/pages/Perfil/veiculos-page.dart';
import 'package:vitoria_forte/widget/menu-widget.dart';
import 'package:vitoria_forte/widget/textfield_widget.dart';
import 'package:flutter/widgets.dart';

import '../../constants.dart';
import '../index.dart';
import 'minha-moradia-page.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  Usuario userPage = new Usuario();
  final picker = ImagePicker();
  final ImagePicker _picker = ImagePicker();
  File _imageFile;

  String fotoUsuario =
      "https://i.pinimg.com/236x/67/35/5f/67355f52a7c5f12a4660eabae6fb334a.jpg";

  @override
  void initState() {
    _getUser();
  }

  Widget horizontalList1 = new Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 200.0,
      child: new ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            width: 160.0,
            color: Colors.red,
          ),
          Container(
            width: 160.0,
            color: Colors.orange,
          ),
          Container(
            width: 160.0,
            color: Colors.pink,
          ),
          Container(
            width: 160.0,
            color: Colors.yellow,
          ),
        ],
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Perfil',
        ),
        leading: MenuWidget(),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              imageProfile(),
              SizedBox(height: 24),
              // Text(this.userPage.nome.toString()),
              TextFieldWidget(
                label: 'Nome:',
                text: this.userPage.nome.toString(),
              ),
              SizedBox(height: 15),
              TextFieldWidget(
                label: 'CPF:',
                text: this.userPage.cpf.toString(),
              ),
              SizedBox(height: 15),
              // TextFieldWidget(
              //   label: 'Data Nascimento:',
              //   text: this.userPage.dataNascimentoFormat.toString(),
              // ),
              SizedBox(height: 15),
              TextFieldWidget(
                label: 'Email:',
                text: this.userPage.email.toString(),
              ),
              SizedBox(height: 15),
              // TextFieldWidget(
              //   label: 'Telefone:',
              //   text: this.userPage.telefone.toString(),
              // ),
              SizedBox(height: 15),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildContainer(
                        context, 'DADOS PESSOAIS', FontAwesomeIcons.userAlt, 4),
                    _buildContainer(
                        context, 'MINHA RESIDÊNCIA', FontAwesomeIcons.home, 3),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildContainer(
                        context, 'MEUS VEÍCULOS', FontAwesomeIcons.car, 1),
                    _buildContainer(context, 'CONTATOS EMERGÊNCIA',
                        FontAwesomeIcons.contao, 2),
                  ],
                ),
              ),

              //_buildListViewVeiculos()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListViewVeiculos() {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        //width: MediaQuery.of(context).size.width * 0.3,
        child: Center(
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              _buildContainer(
                  context, 'DADOS PESSOAIS', FontAwesomeIcons.userAlt, 4),
              _buildContainer(
                  context, 'MINHA MORADIA', FontAwesomeIcons.home, 3),
              _buildContainer(
                  context, 'MEUS VEÍCULOS', FontAwesomeIcons.car, 1),
              _buildContainer(
                  context, 'CONTATOS EMERGÊNCIA', FontAwesomeIcons.contao, 2),
            ],
          ),
        )
        //isThreeLine: true,
        );
  }

  Widget imageProfile() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: ((builder) => bottomSheet()),
        );
      },
      child: Center(
        child: Stack(children: <Widget>[
          _buildCacheImage(),
          // CachedNetworkImage(
          //   maxHeightDiskCache: 200,
          //   imageUrl: 'https://via.placeholder.com/3000x2000',
          // ),
          // CircleAvatar(
          //   radius: 80.0,
          //   backgroundImage: _imageFile == null
          //       ? NetworkImage(this.fotoUsuario)
          //       : FileImage(File(_imageFile.path)),
          // ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.teal,
                size: 28.0,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildCacheImage() {
    return CachedNetworkImage(
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => new Icon(Icons.error),
      fit: BoxFit.contain,
      imageUrl: 'https://via.placeholder.com/3000x2000',
      imageBuilder: (context, imageProvider) {
        return CircleAvatar(
          radius: 80.0,
          backgroundImage: _imageFile == null
              ? NetworkImage(this.fotoUsuario)
              : FileImage(File(_imageFile.path)),
        );
      },
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

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );

    File imageCropped;

    if (pickedFile != null) {
      File cropped = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 35,
        maxHeight: 700,
        maxWidth: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Camera',
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Camera',
        ),
      );

      setState(() {
        if (cropped != null) {
          _imageFile = cropped;
        } else {
          _imageFile = File(pickedFile.path);
        }

        try {
          Uint8List arrayBYtes;
          String myPath = _imageFile.path;
          _readFileByte(myPath).then((bytesData) {
            arrayBYtes = bytesData;
            String arrayBytesString = base64.encode(arrayBYtes);
            _salvarFoto(arrayBytesString);
            print(arrayBytesString);
          });
        } catch (e) {
          // if path invalid or not able to read
          print(e);
        }

        // var array = _readFileByte(_imageFile.path);
        // print(array.toString());
        // _salvarFoto(array);
        Navigator.pop(context);
      });
    }
  }

  _salvarFoto(String base64) async {
    final response = await http.post(
      Uri.parse('${baseUrl}Usuario/SalvarFoto'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'base64': base64, 'userCpf': this.userPage.cpf}),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (response.body != "") {
        _saveUserLocalStore(response.body);
      }
      _getUser();
    }
  }

  Future<Uint8List> _readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File audioFile = new File.fromUri(myUri);
    Uint8List bytes;
    await audioFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      print('reading of bytes is completed');
    }).catchError((onError) {
      print('Exception Error while reading audio from path:' +
          onError.toString());
    });
    return bytes;
  }

  _saveUserLocalStore(String userJson) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userJson', userJson);
  }

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> userMap = jsonDecode(prefs.getString('userJson'));
      Usuario user = new Usuario();
      user = Usuario.fromJson(userMap);
      setState(() {
        this.userPage = user;
        if (this.userPage.foto != "") {
          this.fotoUsuario = url + "/" + this.userPage.foto;
        }
      });
    } catch (e) {}
  }

  Widget _buildContainer(
      BuildContext context, String msgBtn, IconData icon, int page) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () {
          if (page == 1) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => VeiculosPage()));
          }
          if (page == 2) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ContatosEmergenciaPage()));
          }
          if (page == 3) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MinhaMoradiaPage()));
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.17,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(
              color: Colors.black,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                  child: FaIcon(
                icon,
                size: MediaQuery.of(context).size.width * 0.06,
              )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.014,
              ),
              Center(
                child: Text(
                  msgBtn,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
