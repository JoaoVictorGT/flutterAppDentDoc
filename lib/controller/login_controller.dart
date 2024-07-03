// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../view/util.dart';

class LoginController {
  //
  // CRIAR CONTA de um usuário no serviço Firebase Authentication
  //
  criarConta(context, nome, email, senha) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: senha,
    )
        .then(
      (resultado) {
        //Usuário criado com sucesso!

        //Armazenar o NOME e UID do usuário no Firestore
        FirebaseFirestore.instance.collection("usuarios").add(
          {
            "uid": resultado.user!.uid,
            "nome": nome,
          },
        );
        sucesso(context, 'Usuário criado com sucesso!');
        Navigator.pop(context);
      },
    ).catchError((e) {
      //Erro durante a criação do usuário
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

  //
  // Verificar se o email pertence aos domínios permitidos
  //
  bool isEmailValid(String email) {
    const professorDomain = '@unaerp.br';
    const alunoDomain = '@sou.unaerp.edu.br';

    return email.endsWith(professorDomain) || email.endsWith(alunoDomain);
  }

  //
  // LOGIN de usuário a partir do provedor Email/Senha
  //
  login(context, email, senha) {
    if (!isEmailValid(email)) {
      erro(context, 'Domínio de email não permitido.');
      return;
    }

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((resultado) {
      sucesso(context, 'Usuário autenticado com sucesso!');
      Navigator.pushNamed(context, 'principal');
    }).catchError((e) {
      switch (e.code) {
        case 'invalid-email':
          erro(context, 'O formato do e-mail é inválido.');
          break;
        case 'user-not-found':
          erro(context, 'Usuário não encontrado.');
          break;
        case 'wrong-password':
          erro(context, 'Senha incorreta.');
          break;
        default:
          erro(context, 'ERRO: ${e.code.toString()}');
      }
    });
  }

  // Valida se o email pertence ao domínio de alunos
  bool isAlunoEmailValid(String email) {
    return email.endsWith('@sou.unaerp.edu.br');
  }

  Future<void> esqueceuSenha(BuildContext context, String email) async {
    if (!isAlunoEmailValid(email)) {
      erro(context, 'O email deve ser do domínio @sou.unaerp.edu.br.');
      return;
    }

    if (email.isNotEmpty) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        sucesso(context, 'Email enviado com sucesso.');
        Navigator.of(context).pop(); // Fechar o diálogo após o sucesso
      } catch (e) {
        erro(context, 'Erro ao enviar email: ${e.toString()}');
      }
    } else {
      erro(context, 'Informe o email para recuperar a conta.');
    }
  }

  //
  // Efetuar logou do usuário
  //
  logout() {
    FirebaseAuth.instance.signOut();
  }

  //Obter o tipo do usuário
  Future<String> getUserType() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userData = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('uid', isEqualTo: user.uid)
          .limit(1)
          .get();
      if (userData.docs.isNotEmpty) {
        return userData.docs.first['tipo'] ?? '';
      }
    }
    return '';
  }

  //
  // Retornar o UID (User Identifier) do usuário que está logado no App
  //
  idUsuarioLogado() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  bool isProfessor() {
    String email = FirebaseAuth.instance.currentUser!.email ?? '';
    return email.endsWith('@unaerp.br');
  }

  bool isAluno() {
    String email = FirebaseAuth.instance.currentUser!.email ?? '';
    return email.endsWith('@sou.unaerp.edu.br');
  }
}
