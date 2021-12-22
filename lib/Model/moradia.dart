class Moradia {
  String setor;
  String local;
  String quadra;
  String lote;
  String rua;
  String nLogradouro;
  Moradia(
      {this.setor = "",
      this.local = "",
      this.quadra = "",
      this.lote = "",
      this.rua = "",
      this.nLogradouro = ""});

  Moradia.fromJson(Map<String, dynamic> json) {
    setor = json['setor'];
    local = json['local'];
    quadra = json['quadra'];
    lote = json['lote'];
    rua = json['rua'];
    nLogradouro = json['nLogradouro'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['setor'] = this.setor;
    data['local'] = this.local;
    data['quadra'] = this.quadra;
    data['lote'] = this.lote;
    data['rua'] = this.rua;
    data['nLogradouro'] = this.nLogradouro;
    return data;
  }
}
