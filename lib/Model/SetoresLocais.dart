class SetoresLocais {
  List<ListSetores> listSetores;
  List<ListLocais> listLocais;
  List<ListQuadra> listQuadra;
  List<ListLote> listLote;
  List<ListRua> listRua;

  SetoresLocais(
      {this.listSetores,
      this.listLocais,
      this.listQuadra,
      this.listLote,
      this.listRua});

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
    if (json['listQuadra'] != null) {
      listQuadra = new List<ListQuadra>();
      json['listQuadra'].forEach((v) {
        listQuadra.add(new ListQuadra.fromJson(v));
      });
    }

    if (json['listLote'] != null) {
      listLote = new List<ListLote>();
      json['listLote'].forEach((v) {
        listLote.add(new ListLote.fromJson(v));
      });
    }

    if (json['listRua'] != null) {
      listRua = [];
      json['listRua'].forEach((v) {
        listRua.add(new ListRua.fromJson(v));
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
    if (this.listQuadra != null) {
      data['listQuadra'] = this.listQuadra.map((v) => v.toJson()).toList();
    }
    if (this.listLote != null) {
      data['listLote'] = this.listLote.map((v) => v.toJson()).toList();
    }
    if (this.listRua != null) {
      data['listRua'] = this.listRua.map((v) => v.toJson()).toList();
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

class ListLote {
  int id;
  int idCondominio;
  int idQuadra;
  String descricao;
  int status;
  String dataCriacao;
  String descricaoCondominio;
  String descricaoQuadra;

  ListLote(
      {this.id,
      this.idCondominio,
      this.idQuadra,
      this.descricao,
      this.status,
      this.dataCriacao,
      this.descricaoCondominio,
      this.descricaoQuadra});

  ListLote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idCondominio = json['idCondominio'];
    idQuadra = json['idQuadra'];
    descricao = json['descricao'];
    status = json['status'];
    dataCriacao = json['dataCriacao'];
    descricaoCondominio = json['descricaoCondominio'];
    descricaoQuadra = json['descricaoQuadra'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idCondominio'] = this.idCondominio;
    data['idQuadra'] = this.idQuadra;
    data['descricao'] = this.descricao;
    data['status'] = this.status;
    data['dataCriacao'] = this.dataCriacao;
    data['descricaoCondominio'] = this.descricaoCondominio;
    data['descricaoQuadra'] = this.descricaoQuadra;
    return data;
  }
}

class ListQuadra {
  int id;
  int idCondominio;
  String descricao;
  int status;
  String dataCriacao;
  String descricaoCondominio;

  ListQuadra(
      {this.id,
      this.idCondominio,
      this.descricao,
      this.status,
      this.dataCriacao,
      this.descricaoCondominio});

  ListQuadra.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idCondominio = json['idCondominio'];
    descricao = json['descricao'];
    status = json['status'];
    dataCriacao = json['dataCriacao'];
    descricaoCondominio = json['descricaoCondominio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idCondominio'] = this.idCondominio;
    data['descricao'] = this.descricao;
    data['status'] = this.status;
    data['dataCriacao'] = this.dataCriacao;
    data['descricaoCondominio'] = this.descricaoCondominio;
    return data;
  }
}

class ListRua {
  int id;
  int idCondominio;
  String descricao;
  int status;
  String dataCriacao;
  Null descricaoCondominio;

  ListRua(
      {this.id,
      this.idCondominio,
      this.descricao,
      this.status,
      this.dataCriacao,
      this.descricaoCondominio});

  ListRua.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idCondominio = json['idCondominio'];
    descricao = json['descricao'];
    status = json['status'];
    dataCriacao = json['dataCriacao'];
    descricaoCondominio = json['descricaoCondominio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idCondominio'] = this.idCondominio;
    data['descricao'] = this.descricao;
    data['status'] = this.status;
    data['dataCriacao'] = this.dataCriacao;
    data['descricaoCondominio'] = this.descricaoCondominio;
    return data;
  }
}
