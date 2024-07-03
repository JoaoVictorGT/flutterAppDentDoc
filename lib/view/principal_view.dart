// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controller/login_controller.dart';
import '../controller/termo_controller.dart';
import '../model/termo.dart';

class PrincipalView extends StatefulWidget {
  const PrincipalView({Key? key}) : super(key: key);

  @override
  State<PrincipalView> createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  var txtTitulo = TextEditingController();
  var txtDescricao = TextEditingController();
  var txtStatus = TextEditingController();
  var txtSearch = TextEditingController();
  String searchQuery = "";
  String userType = "";
  bool showOnlyEnabled = false;

  List<String> statusOptions = ['Habilitado', 'Desabilitado'];

  String selectedStatus = 'Habilitado';

  @override
  void initState() {
    super.initState();
    _getUserType();
  }

  void _getUserType() async {
    String tipo = await LoginController().getUserType();
    setState(() {
      userType = tipo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: SafeArea(
          child: AppBar(
            automaticallyImplyLeading: false,
            title: SizedBox(
              height: 250,
              //mainAxisAlignment: MainAxisAlignment.center,
              child: Image.asset(
                'assets/images/logo-top.png',
                fit: BoxFit.contain,
                height: 32,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.exit_to_app),
                color: Colors.blueAccent,
                tooltip: 'Sair',
                onPressed: () {
                  LoginController().logout();
                  Navigator.pushReplacementNamed(context, 'login');
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: txtSearch,
              decoration: InputDecoration(
                hintText: 'Busca de Termos Técnicos',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search, color: Colors.black),
              ),
              style: TextStyle(color: Colors.black, fontSize: 18.0),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Status:',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(width: 2),
                Switch(
                  value: showOnlyEnabled,
                  onChanged: (value) {
                    setState(() {
                      showOnlyEnabled = value;
                    });
                  },
                ),
                Text(
                  showOnlyEnabled ? 'Habilitados' : 'Todos',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: TermoController().listar().snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Erro ao carregar os termos.'),
                    );
                  }

                  final dados = snapshot.requireData;
                  final termosFiltrados = dados.docs.where((doc) {
                    var termo = doc.data() as Map<String, dynamic>;
                    var titulo = termo['titulo'].toString().toLowerCase();
                    var query = searchQuery.toLowerCase();
                    var status = termo['status'];

                    bool matchesSearch = titulo.contains(query);
                    bool isEnabled = status == 'Habilitado';

                    return matchesSearch && (!showOnlyEnabled || isEnabled);
                  }).toList();

                  if (termosFiltrados.isEmpty) {
                    return Center(
                      child: Text('Nenhum termo encontrado.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: termosFiltrados.length,
                    itemBuilder: (context, index) {
                      String id = termosFiltrados[index].id;
                      dynamic doc = termosFiltrados[index].data();
                      return Card(
                        child: ListTile(
                          title: Text(doc['titulo']),
                          subtitle: Text(doc['descricao']),
                          trailing: LoginController().isProfessor()
                              ? SizedBox(
                                  width: 70,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: IconButton(
                                          onPressed: () {
                                            txtTitulo.text = doc['titulo'];
                                            txtDescricao.text =
                                                doc['descricao'];
                                            salvarTermo(context, docId: id);
                                          },
                                          icon: Icon(Icons.edit_outlined),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          TermoController()
                                              .excluir(context, id);
                                        },
                                        icon: Icon(Icons.delete_outlined),
                                      ),
                                    ],
                                  ),
                                )
                              : null,
                          onTap: () {
                            if (LoginController().isAluno()) {
                              Clipboard.setData(
                                  ClipboardData(text: doc['descricao']));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Conteúdo copiado.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {}
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          salvarTermo(context);
        },
        backgroundColor: Colors.blueAccent.withOpacity(0.6),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void salvarTermo(context, {docId}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(docId == null ? "Adicionar Termo" : "Editar Termo"),
          content: SingleChildScrollView(
            child: SizedBox(
              height: 300,
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: txtTitulo,
                    decoration: InputDecoration(
                      labelText: 'Título',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: txtDescricao,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text('Status:'),
                      SizedBox(width: 8),
                      DropdownButton<String>(
                        value: selectedStatus,
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value!;
                          });
                        },
                        items: <String>['Habilitado', 'Desabilitado']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: EdgeInsets.all(10),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size(100, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.blueAccent),
                  ),
                  child: Text(
                    "Fechar",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onPressed: () {
                    txtTitulo.clear();
                    txtDescricao.clear();
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(100, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: Text(
                    "Salvar",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    var t = Termo(
                      LoginController().idUsuarioLogado(),
                      txtTitulo.text,
                      txtDescricao.text,
                      status: selectedStatus,
                    );

                    txtTitulo.clear();
                    txtDescricao.clear();

                    if (docId == null) {
                      TermoController().adicionar(context, t);
                    } else {
                      TermoController().atualizar(context, docId, t);
                    }

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
