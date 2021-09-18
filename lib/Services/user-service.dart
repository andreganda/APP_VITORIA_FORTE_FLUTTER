import 'dart:convert';
import 'dart:html';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitoria_forte/Model/Usuario.dart';

class UserService {
  Future<Usuario> GetUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> userMap = jsonDecode(prefs.getString('userJson'));
      Usuario user = new Usuario();
      user = Usuario.fromJson(userMap);
      return user;
    } catch (e) {
      return null;
    }
  }
}
