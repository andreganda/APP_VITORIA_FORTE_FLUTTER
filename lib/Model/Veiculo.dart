class Veiculo {
  int id;
  String userCpf;
  String modelo;
  String placa;

  Veiculo({this.id, this.userCpf, this.modelo, this.placa});

  Veiculo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userCpf = json['userCpf'];
    modelo = json['modelo'];
    placa = json['placa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userCpf'] = this.userCpf;
    data['modelo'] = this.modelo;
    data['placa'] = this.placa;
    return data;
  }
}
