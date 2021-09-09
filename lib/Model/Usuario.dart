class Usuario {
  int tipoUsuario;
  String funcao;
  int localDeTrabalho;
  String senha;
  int errosSenha;
  int id;
  String cpf;
  String nome;
  String dataNascimento;
  String telefone;
  String email;
  String dataCriacao;
  String dataAlteracao;
  String cep;
  String logradouro;
  String numero;
  String complemento;
  String bairro;
  String cidade;
  String uf;

  Usuario(
      {this.tipoUsuario,
      this.funcao,
      this.localDeTrabalho,
      this.senha,
      this.errosSenha,
      this.id,
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
      this.uf});

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
    data['dataNascimento'] = this.dataNascimento;
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
    return data;
  }
}
