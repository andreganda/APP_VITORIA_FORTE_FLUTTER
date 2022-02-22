// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitoria_forte/Model/Usuario.dart';
import 'package:vitoria_forte/constants.dart';

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

  // ignore: non_constant_identifier_names, missing_return
  Future<int> ContadorNotificacoes(String cpf) async {
    try {
      final response = await http.get(
          Uri.parse(
              '${baseUrl}Notificacao/contador_notificacoes_nao_lidas?cpf=' +
                  cpf),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body != "") {
          return int.parse(response.body);
        }
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  // ignore: non_constant_identifier_names, missing_return
  Future<int> SetarNotificacaoComoLida(int idNotificacao, String cpf) async {
    try {
      final response = await http.get(
          Uri.parse(
              '${baseUrl}Notificacao/setar_notificacao_como_lida?idNotificacao=${idNotificacao}&cpf=${cpf}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body != "") {}
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
}
