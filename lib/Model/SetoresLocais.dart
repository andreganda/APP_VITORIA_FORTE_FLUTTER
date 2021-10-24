class SetoresLocais {
  List<ListSetores> listSetores;
  List<ListLocais> listLocais;

  SetoresLocais({this.listSetores, this.listLocais});

  SetoresLocais.fromJson(Map<String, dynamic> json) {
    if (json['listSetores'] != null) {
      listSetores = new List<ListSetores>();
      json['listSetores'].forEach((v) {
        listSetores.add(new ListSetores.fromJson(v));
      });
    }
    if (json['listLocais'] != null) {
      listLocais = new List<ListLocais>();
      json['listLocais'].forEach((v) {
        listLocais.add(new ListLocais.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listSetores != null) {
      data['listSetores'] = this.listSetores.map((v) => v.toJson()).toList();
    }
    if (this.listLocais != null) {
      data['listLocais'] = this.listLocais.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListSetores {
  int id;
  int idCondominio;
  String descricaoCondominio;
  String descricao;
  int status;
  String dataCriacao;

  ListSetores(
      {this.id,
      this.idCondominio,
      this.descricaoCondominio,
      this.descricao,
      this.status,
      this.dataCriacao});

  ListSetores.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idCondominio = json['idCondominio'];
    descricaoCondominio = json['descricaoCondominio'];
    descricao = json['descricao'];
    status = json['status'];
    dataCriacao = json['dataCriacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idCondominio'] = this.idCondominio;
    data['descricaoCondominio'] = this.descricaoCondominio;
    data['descricao'] = this.descricao;
    data['status'] = this.status;
    data['dataCriacao'] = this.dataCriacao;
    return data;
  }
}

class ListLocais {
  int id;
  int idCondominio;
  int idSetor;
  String descricao;
  int status;
  String dataCriacao;
  String descricaoCondominio;
  String descricaoSetor;

  ListLocais(
      {this.id,
      this.idCondominio,
      this.idSetor,
      this.descricao,
      this.status,
      this.dataCriacao,
      this.descricaoCondominio,
      this.descricaoSetor});

  ListLocais.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idCondominio = json['idCondominio'];
    idSetor = json['idSetor'];
    descricao = json['descricao'];
    status = json['status'];
    dataCriacao = json['dataCriacao'];
    descricaoCondominio = json['descricaoCondominio'];
    descricaoSetor = json['descricaoSetor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idCondominio'] = this.idCondominio;
    data['idSetor'] = this.idSetor;
    data['descricao'] = this.descricao;
    data['status'] = this.status;
    data['dataCriacao'] = this.dataCriacao;
    data['descricaoCondominio'] = this.descricaoCondominio;
    data['descricaoSetor'] = this.descricaoSetor;
    return data;
  }
}
