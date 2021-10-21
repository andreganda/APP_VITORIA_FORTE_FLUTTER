class SetoresLocais {
  List<String> listSetores;
  List<String> listLocais;

  SetoresLocais({this.listSetores, this.listLocais});

  SetoresLocais.fromJson(Map<String, dynamic> json) {
    listSetores = json['listSetores'].cast<String>();
    listLocais = json['listLocais'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listSetores'] = this.listSetores;
    data['listLocais'] = this.listLocais;
    return data;
  }
}
