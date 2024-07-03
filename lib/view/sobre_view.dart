// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';

class SobreNosView extends StatelessWidget {
  const SobreNosView({super.key});

  void _showDonationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/pix.png'),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(100, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Fechar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 70, 30, 50),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 600, // Defina a altura máxima que você deseja
          ),
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
                  //   child: Image.asset('assets/images/Aboutus.png'),
                  // ),
                  SizedBox(height: 20),
                  Text(
                    'Sobre Nós',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Somos Arthur Fedeli e João Victor Thomazini fundadores da DentDoc.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFFA8A8A8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Nossa missão é proporcionar uma experiência única de aprendizagem e ensino na área odontológica, tornando o acesso a materiais educacionais de qualidade mais fácil e eficiente.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFFA8A8A8),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Obrigado por se juntar a nós nesta jornada. Estamos animados para fazer parte da sua jornada educacional e esperamos que você encontre na DentDoc uma fonte valiosa de recursos e inspiração.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFFA8A8A8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          _showDonationDialog(context);
                          Image.asset('assets/images/pix.png');
                        },
                        child: Text(
                          'Enviar Doação',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                      // SizedBox(width: 10),
                      // TextButton(
                      //   onPressed: () {
                      //     // Implementar lógica de envio de mensagem
                      //   },
                      //   child: Text(
                      //     'Enviar Mensagem',
                      //     style: TextStyle(color: Colors.blueAccent),
                      //   ),
                      // ),
                    ],
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
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Voltar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
