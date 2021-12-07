class Veiculo {
  String Placa;
  String Modelo;

  Veiculo({this.Placa, this.Modelo});

  Map<String, dynamic> toJson() {
    return {
      'Placa': Placa,
      'Modelo': Modelo,
    };
  }
}
