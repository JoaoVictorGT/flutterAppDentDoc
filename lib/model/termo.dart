class Termo {
  final String uid;
  final String titulo;
  final String descricao;
  final String status;

  Termo(this.uid, this.titulo, this.descricao, {this.status = ""});

  //Transforma um OBJETO em JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'titulo': titulo,
      'descricao': descricao,
      'status': status,
    };
  }

  //Transforma um JSON em OBJETO
  factory Termo.fromJson(Map<String, dynamic> json) {
    return Termo(
      json['uid'],
      json['titulo'],
      json['descricao'],
      status: json['status'] ?? '',
    );
  }
}
