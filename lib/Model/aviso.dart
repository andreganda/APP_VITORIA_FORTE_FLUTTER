import 'package:intl/intl.dart';

class Aviso {
  int id;
  int idCondominio;
  String titulo;
  String mensagem;
  int status;
  String data;
  String dataFormat;
  String userCpf;

  Aviso(
      {this.id,
      this.idCondominio,
      this.titulo,
      this.mensagem,
      this.status,
      this.data,
      this.userCpf});

  Aviso.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idCondominio = json['idCondominio'];
    titulo = json['titulo'];
    mensagem = json['mensagem'];
    status = json['status'];
    data = json['data'];
    userCpf = json['userCpf'];

    var parsedDate = DateTime.parse(data);
    final DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm');
    dataFormat = formatter.format(parsedDate);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idCondominio'] = this.idCondominio;
    data['titulo'] = this.titulo;
    data['mensagem'] = this.mensagem;
    data['status'] = this.status;
    data['data'] = this.data;
    data['userCpf'] = this.userCpf;
    return data;
  }
}
