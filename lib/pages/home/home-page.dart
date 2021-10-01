import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vitoria_forte/pages/denunciar/denunciar-page.dart';
import 'package:vitoria_forte/pages/index.dart';
import 'package:vitoria_forte/pages/panico/botao-panico.dart';
import 'package:vitoria_forte/widget/menu-widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              _buildContainer(
                  context, 'SOCORRO', FontAwesomeIcons.exclamationTriangle, 1),
              _buildContainer(
                  context, 'DENUNCIAR', FontAwesomeIcons.fileContract, 2),
              _buildContainer(context, 'PERFIL', FontAwesomeIcons.accusoft, 3),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildContainer(
    BuildContext context, String msgBtn, IconData icon, int page) {
  return Padding(
    padding: EdgeInsets.all(8),
    child: GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => IndexPage(
                  currentPage: 1,
                )));
      },
      child: Container(
        height: 150,
        width: 200,
        decoration: BoxDecoration(
          color: Colors.red,
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
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    ),
  );
}
