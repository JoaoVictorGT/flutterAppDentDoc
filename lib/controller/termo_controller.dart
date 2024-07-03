import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/termo.dart';
import '../view/util.dart';
//import 'login_controller.dart';

class TermoController {
  //Adicionar um novo termo
  adicionar(context, Termo t) {
    FirebaseFirestore.instance
        .collection('termos')
        .add(t.toJson())
        .then((resultado) {
      sucesso(context, 'Termo adicionado com sucesso!');
    }).catchError((e) {
      erro(context, 'Não foi possível adicionar este termo.');
    }).whenComplete(() => Navigator.pop(context));
  }

  //Listar todas os termos do usuário logado
  listar() {
    return FirebaseFirestore.instance.collection('termos');
    //.where('uid', isEqualTo: LoginController().idUsuarioLogado());
  }

  //Excluir termos
  excluir(context, id) {
    FirebaseFirestore.instance
        .collection('termos')
        .doc(id)
        .delete()
        .then((value) => sucesso(context, 'Termo excluído com sucesso!'))
        .catchError(
            (e) => erro(context, 'Não foi possível excluir este termo.'));
  }

  //Atualizar um termo
  atualizar(context, id, Termo t) {
    FirebaseFirestore.instance
        .collection('termos')
        .doc(id)
        .update(t.toJson())
        .then((value) => sucesso(context, 'Termo atualizado com sucesso!'))
        .catchError(
            (e) => erro(context, 'Não foi possível atualizar este termo.'))
        .whenComplete(() => Navigator.pop(context));
  }
}
