import 'package:intl/intl.dart';

class Usuario {
  int tipoUsuario;
  String funcao;
  int localDeTrabalho;
  String senha;
  int errosSenha;
  int id;
  int status;
  String cpf;
  String nome;
  String dataNascimento;
  String dataNascimentoFormat;
  String telefone;
  String email;
  String dataCriacao;
  String dataCriacaoFormat;
  String dataAlteracao;
  String cep;
  String logradouro;
  String numero;
  String complemento;
  String bairro;
  String cidade;
  String uf;
  String foto;
  int primeiroAcesso;

  Usuario(
      {this.tipoUsuario,
      this.funcao,
      this.localDeTrabalho,
      this.senha,
      this.errosSenha,
      this.id,
      this.status,
      this.cpf,
      this.nome,
      this.dataNascimento,
      this.telefone,
      this.email,
      this.dataCriacao,
      this.dataAlteracao,
      this.cep,
      this.logradouro,
      this.numero,
      this.complemento,
      this.bairro,
      this.cidade,
      this.uf,
      this.foto,
      this.primeiroAcesso});

  Usuario.fromJson(Map<String, dynamic> json) {
    tipoUsuario = json['tipoUsuario'];
    funcao = json['funcao'];
    localDeTrabalho = json['localDeTrabalho'];
    senha = json['senha'];
    errosSenha = json['errosSenha'];
    id = json['id'];
    cpf = json['cpf'];
    nome = json['nome'];
    dataNascimento = json['dataNascimento'];
    telefone = json['telefone'];
    email = json['email'];
    dataCriacao = json['dataCriacao'];
    dataAlteracao = json['dataAlteracao'];
    cep = json['cep'];
    logradouro = json['logradouro'];
    numero = json['numero'];
    complemento = json['complemento'];
    bairro = json['bairro'];
    cidade = json['cidade'];
    uf = json['uf'];
    foto = json['foto'];
    status = json['status'];
    primeiroAcesso = json['primeiroAcesso'];

    var parsedDate = DateTime.parse(dataNascimento);
    var parsedDateCriacao = DateTime.parse(dataCriacao);

    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    dataNascimentoFormat = formatter.format(parsedDate);

    dataCriacaoFormat = formatter.format(parsedDateCriacao);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tipoUsuario'] = this.tipoUsuario;
    data['funcao'] = this.funcao;
    data['localDeTrabalho'] = this.localDeTrabalho;
    data['senha'] = this.senha;
    data['errosSenha'] = this.errosSenha;
    data['id'] = this.id;
    data['cpf'] = this.cpf;
    data['nome'] = this.nome;
    data['dataNascimento'] = this.dataNascimento.toString();
    data['telefone'] = this.telefone;
    data['email'] = this.email;
    data['dataCriacao'] = this.dataCriacao;
    data['dataAlteracao'] = this.dataAlteracao;
    data['cep'] = this.cep;
    data['logradouro'] = this.logradouro;
    data['numero'] = this.numero;
    data['complemento'] = this.complemento;
    data['bairro'] = this.bairro;
    data['cidade'] = this.cidade;
    data['uf'] = this.uf;
    data['foto'] = this.foto;
    data['status'] = this.status;
    data['primeiroAcesso'] = this.primeiroAcesso;
    return data;
  }
}
