// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:app08/view/util.dart';
import 'package:flutter/material.dart';
import '../controller/cadastro_controller.dart';

class CadastrarView extends StatefulWidget {
  const CadastrarView({super.key});

  @override
  State<CadastrarView> createState() => _CadastrarViewState();
}

class _CadastrarViewState extends State<CadastrarView> {
  var txtNome = TextEditingController();
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();
  var txtConfirmarSenha = TextEditingController();
  var txtMatricula = TextEditingController();

  String? emailError;
  final cadastroController = CadastroController();
  String? selectedUserType;
  final userTypes = ['Aluno', 'Professor'];
  @override
  void initState() {
    super.initState();
    selectedUserType = userTypes[0];
  }

  void validateEmail(String email) {
    if (!cadastroController.isEmailValid(email)) {
      setState(() {
        emailError = 'Domínio de email não permitido.';
      });
    } else {
      setState(() {
        emailError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 60, 30, 50),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 0.5,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Container(
                  //   width: 150,
                  //   height: 150,
                  //   child: Image.asset(
                  //       'assets/images/Signup.png'),
                  // ),
                  SizedBox(height: 20),
                  Text(
                    'Cadastro DentDoc!',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Crie já sua conta em nossa plataforma digital para ensino.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(168, 168, 168, 168),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: txtNome,
                    decoration: InputDecoration(
                      labelText: 'Nome Completo',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: txtEmail,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                      errorText: emailError,
                    ),
                    onChanged: (value) {
                      validateEmail(value);
                    },
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: txtSenha,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.password),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: txtConfirmarSenha,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Senha',
                      prefixIcon: Icon(Icons.password),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: selectedUserType,
                    decoration: InputDecoration(
                      labelText: 'Tipo de Usuário',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    items: userTypes.map((String userType) {
                      return DropdownMenuItem<String>(
                        value: userType,
                        child: Text(userType),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedUserType = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  if (selectedUserType == 'Aluno')
                    TextField(
                      controller: txtMatricula,
                      decoration: InputDecoration(
                        labelText: 'Código de Matrícula',
                        prefixIcon: Icon(Icons.school),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(120, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.blueAccent),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                      SizedBox(width: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(120, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blueAccent,
                        ),
                        onPressed: () {
                          if (txtSenha.text == txtConfirmarSenha.text) {
                            if (emailError == null) {
                              if (selectedUserType == 'Aluno' &&
                                  txtMatricula.text.isEmpty) {
                                erro(context,
                                    'Por favor, insira o código de matrícula.');
                              } else {
                                cadastroController.criarConta(
                                  context,
                                  txtNome.text,
                                  txtEmail.text,
                                  txtSenha.text,
                                  selectedUserType == 'Aluno'
                                      ? txtMatricula.text
                                      : null, // Passa o código de matrícula se for aluno
                                );
                              }
                            } else {
                              erro(context,
                                  'Por favor, corrija os erros antes de continuar.');
                            }
                          } else {
                            // Mostrar mensagem de erro se as senhas não correspondem
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Erro'),
                                  content: Text('As senhas não correspondem!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text(
                          'Salvar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
