import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:vitoria_forte/Model/notification.dart';
import 'package:vitoria_forte/Services/user-service.dart';
//import 'package:vitoria_forte/pages/denunciar/denunciar-page.dart';
import 'package:vitoria_forte/pages/index.dart';
//import 'package:vitoria_forte/pages/panico/botao-panico.dart';
import 'package:vitoria_forte/widget/menu-widget.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

int contador = 0;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    Future.delayed(Duration.zero).then((_) {
      getContadorNotificacoes();
    });
    super.initState();
  }

  _changeBody(String msg) {
    setState(() {
      getContadorNotificacoes();
      showAlertDialog(context, "Nova Notificação", msg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'Inicio',
        ),
        leading: MenuWidget(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: GridView.count(
            //primary: false,
            //padding: const EdgeInsets.all(20),
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            crossAxisCount: 2,
            children: <Widget>[
              _buildContainer(
                  context, 'SOCORRO', FontAwesomeIcons.exclamationTriangle, 1),
              _buildContainer(
                  context, 'DENUNCIAR', FontAwesomeIcons.fileContract, 2),
              _buildContainer(context, 'PERFIL', FontAwesomeIcons.userAlt, 3),
              _buildContainerNotificacao(
                  context, 'AVISOS', Icons.notifications, 4)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getContadorNotificacoes() async {
    try {
      String cpf = "";
      UserService userService = UserService();
      await userService.GetUser().then((value) => cpf = value.cpf);
      await userService.ContadorNotificacoes(cpf).then((value) {
        contador = value;
        if (value <= 0) {
          FlutterAppBadger.removeBadge();
        }
      });
      setState(() {});
    } catch (e) {}
  }
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

Widget _buildContainerNotificacao(
    BuildContext context, String msgBtn, IconData icon, int page) {
  return Padding(
    padding: EdgeInsets.all(8),
    child: GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => IndexPage(
                  currentPage: page,
                )));
      },
      child: Container(
        height: 150,
        width: 200,
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
            contador > 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          child: Center(
                            child: Text(
                              contador.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          alignment: Alignment.bottomRight,
                          width: 30.0,
                          height: 30.0,
                          decoration: new BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    height: 25,
                  ),
            // SizedBox(
            //   height: 5,
            // ),
            Container(
                child: FaIcon(
              icon,
              size: 45,
            )),
            SizedBox(
              height: 5,
            ),
            Text(
              msgBtn,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    ),
  );
}

Widget _buildContainer(
    BuildContext context, String msgBtn, IconData icon, int page) {
  return Padding(
    padding: EdgeInsets.all(8),
    child: GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => IndexPage(
                  currentPage: page,
                )));
      },
      child: Container(
        height: 150,
        width: 200,
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
              height: 20,
            ),
            Container(
                child: FaIcon(
              icon,
              size: 45,
            )),
            SizedBox(
              height: 20,
            ),
            Text(
              msgBtn,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    ),
  );
}
