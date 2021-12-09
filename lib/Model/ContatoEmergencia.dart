class ContatoEmergencia {
  int id;
  String userCpf;
  String nome;
  String telefone;

  ContatoEmergencia({this.id, this.userCpf, this.nome, this.telefone});

  ContatoEmergencia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userCpf = json['userCpf'];
    nome = json['nome'];
    telefone = json['telefone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userCpf'] = this.userCpf;
    data['nome'] = this.nome;
    data['telefone'] = this.telefone;
    return data;
  }
}
