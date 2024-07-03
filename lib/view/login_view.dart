// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import '../controller/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();
  var txtEmailEsqueceuSenha = TextEditingController();

  @override
  void initState() {
    super.initState();
    // txtEmail.text = 'joao.silva@email.com';
    // txtSenha.text = '123456';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(30, 80, 30, 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Image.asset('assets/images/logo-unaerp.png'),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Bem Vindo(a) ao DentDoc!',
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Sua plataforma digital para ensino.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(168, 168, 168, 168),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'sobre');
                            },
                            child: Text(
                              'Sobre Nós',
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      TextField(
                        controller: txtEmail,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
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
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Esqueceu a senha?",
                                    style: TextStyle(color: Colors.blueAccent),
                                  ),
                                  content: Container(
                                    height: 150,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Identifique-se para receber um e-mail com as instruções e o link para criar uma nova senha.",
                                        ),
                                        SizedBox(height: 25),
                                        TextField(
                                          controller: txtEmailEsqueceuSenha,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            prefixIcon: Icon(Icons.email),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actionsPadding: EdgeInsets.all(10),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(100, 40),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            backgroundColor: Colors.white,
                                            side: BorderSide(
                                                color: Colors.blueAccent),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Cancelar',
                                            style: TextStyle(
                                                color: Colors.blueAccent),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(100, 40),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            backgroundColor: Colors.blueAccent,
                                          ),
                                          onPressed: () {
                                            //
                                            // Enviar email recuperação de senha
                                            //
                                            LoginController().esqueceuSenha(
                                              context,
                                              txtEmailEsqueceuSenha.text,
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Enviar',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            'Esqueceu a senha?',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blueAccent,
                        ),
                        onPressed: () {
                          //
                          // LOGIN
                          //
                          LoginController().login(
                            context,
                            txtEmail.text,
                            txtSenha.text,
                          );
                        },
                        child: Text(
                          'Entrar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Ainda não tem conta?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'cadastrar');
                            },
                            child: Text(
                              'Cadastre-se',
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
