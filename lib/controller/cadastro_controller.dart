import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../view/util.dart';

class CadastroController {
  // Valida o domínio do email
  bool isEmailValid(String email) {
    final validDomains = ['unaerp.br', 'sou.unaerp.edu.br'];
    return validDomains.any((domain) => email.endsWith('@$domain'));
  }

  // CRIAR CONTA de um usuário no serviço Firebase Authentication
  criarConta(BuildContext context, String nome, String email, String senha,
      [String? matricula]) {
    if (!isEmailValid(email)) {
      erro(context, 'Domínio de email não permitido.');
      return;
    }

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: senha)
        .then((resultado) {
      // Usuário criado com sucesso!

      // Armazenar o NOME, UID do usuário e matrícula (se for aluno) no Firestore
      var userData = {
        "uid": resultado.user!.uid,
        "nome": nome,
        "tipo": matricula != null
            ? 'Aluno'
            : 'Professor', // Define o tipo de usuário
      };
      if (matricula != null) {
        userData["matricula"] = matricula;
      }

      FirebaseFirestore.instance.collection("usuarios").add(userData);
      sucesso(context, 'Usuário criado com sucesso!');
      Navigator.pop(context);
    }).catchError((e) {
      // Erro durante a criação do usuário
      switch (e.code) {
        case 'email-already-in-use':
          erro(context, 'O email já foi cadastrado.');
          break;
        case 'invalid-email':
          erro(context, 'O formato do e-mail é inválido.');
          break;
        default:
          erro(context, 'ERRO: ${e.toString()}');
      }
    });
  }
}
