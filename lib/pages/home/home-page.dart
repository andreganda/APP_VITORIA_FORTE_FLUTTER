import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:vitoria_forte/Model/notification.dart';
//import 'package:vitoria_forte/pages/denunciar/denunciar-page.dart';
import 'package:vitoria_forte/pages/index.dart';
//import 'package:vitoria_forte/pages/panico/botao-panico.dart';
import 'package:vitoria_forte/widget/menu-widget.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String notificationTitle = "";
  String notificationBody = "";
  String notificationData = "";

  @override
  void initState() {
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();
    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);

    super.initState();
  }

  // _changeData(String msg) {
  //   setState(() { notificationData = msg});
  //   }

  _changeData(String msg) {
    setState(() {
      notificationData = msg;
      //showAlertDialog(context, "Nova Notificação", msg);
    });
  }

  _changeBody(String msg) {
    setState(() {
      notificationBody = msg;
      showAlertDialog(context, "Nova Notificação", msg);
    });
  }

  _changeTitle(String msg) => setState(() => notificationTitle = msg);

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
              _buildContainer(context, 'AVISOS', Icons.notifications, 4)
            ],
          ),
        ),
      ),
    );
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
