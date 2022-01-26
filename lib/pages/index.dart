import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:vitoria_forte/pages/avisos/avisos-page.dart';
import 'package:vitoria_forte/pages/denunciar/denunciar-page.dart';
import 'package:vitoria_forte/pages/panico/botao-panico.dart';
import 'Perfil/perfil-page.dart';
import 'home/home-page.dart';
import 'menu/menu-page.dart';
import 'package:vitoria_forte/Model/menu_item.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();

  int currentPage;

  IndexPage({
    Key key,
    this.currentPage,
  }) : super(key: key);
}

class _IndexPageState extends State<IndexPage> {
  MenuItem currentItem = MenuItems.home;

  @override
  Widget build(BuildContext context) {
    if (widget.currentPage != null) {
      if (widget.currentPage == 1) {
        this.currentItem = MenuItems.botaoPanico;
      }
      if (widget.currentPage == 2) {
        this.currentItem = MenuItems.denuncia;
      }
      if (widget.currentPage == 3) {
        this.currentItem = MenuItems.perfil;
      }
      if (widget.currentPage == 4) {
        this.currentItem = MenuItems.avisos;
      }
      widget.currentPage = null;
    }

    var zoomDrawer = ZoomDrawer(
      style: DrawerStyle.Style1,
      borderRadius: 24,
      slideWidth: MediaQuery.of(context).size.width * 0.7,
      showShadow: true,
      angle: -10.0,
      backgroundColor: Colors.orangeAccent,
      mainScreen: getScreen(),
      menuScreen: Builder(
        builder: (context) => MenuPage(
          currentItem: currentItem,
          onSelectedItem: (item) {
            setState(() {
              currentItem = item;
            });
            ZoomDrawer.of(context).close();
          },
        ),
      ),
    );
    return zoomDrawer;
  }

  Widget getScreen() {
    switch (this.currentItem) {
      case MenuItems.perfil:
        return PerfilPage();
      case MenuItems.home:
        return HomePage();
      case MenuItems.denuncia:
        return DenunciarPage();
      case MenuItems.botaoPanico:
        return PanicoPage();
      case MenuItems.avisos:
        return AvisosPage();
    }
  }
}
