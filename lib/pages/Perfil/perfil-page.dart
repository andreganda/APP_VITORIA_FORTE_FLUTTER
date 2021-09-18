import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitoria_forte/Model/Usuario.dart';
import 'package:vitoria_forte/widget/menu-widget.dart';
import 'package:vitoria_forte/widget/profile_widget.dart';
import 'package:vitoria_forte/widget/textfield_widget.dart';

import '../../constants.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  Usuario userPage = new Usuario();
  final picker = ImagePicker();
  final ImagePicker _picker = ImagePicker();
  File _imageFile;

  @override
  void initState() {
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Perfil',
        ),
        leading: MenuWidget(),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
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
          TextFieldWidget(
            label: 'Data Nascimento:',
            text: this.userPage.dataNascimento.toString(),
          ),
          SizedBox(height: 15),
          TextFieldWidget(
            label: 'Email:',
            text: this.userPage.email.toString(),
          ),
          SizedBox(height: 15),
          TextFieldWidget(
            label: 'Telefone:',
            text: this.userPage.telefone.toString(),
          ),
        ],
      ),
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
          CircleAvatar(
            radius:
                80.0, //backgroundImage: AssetImage("asset/images/logo.png"),
            backgroundImage: _imageFile == null
                ? AssetImage("asset/images/logo.png")
                : FileImage(File(_imageFile.path)),
          ),
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
        compressQuality: 100,
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
            print(arrayBytesString);
          });
        } catch (e) {
          // if path invalid or not able to read
          print(e);
        }

        var array = _readFileByte(_imageFile.path);
        print(array.toString());
        //_salvarFoto(array.to);
        Navigator.pop(context);
      });
    }
  }

  // _salvarFoto(String base64) async {
  //   final response = await http.post(
  //     Uri.parse('${baseUrl}Usuario/salvar_foto_usuario'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'base64': base64,
  //     }),
  //   );

  //   if (response.statusCode == 200) {}
  // }

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

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> userMap = jsonDecode(prefs.getString('userJson'));
      Usuario user = new Usuario();
      user = Usuario.fromJson(userMap);
      setState(() {
        this.userPage = user;
      });
    } catch (e) {}
  }
}
