// novo arquivo: lib/screens/dashboard.dart
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),

      // corpo principal da tela
      body: Column(
        // alinhamento vertical
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        // alinhamento horizontal
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          // logotipo com margem
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset("images/bytebank_logo.png"),
          ),

          // container de contatos com padding
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // margem interna
              padding: const EdgeInsets.all(8.0),

              // dimensões ajustadas conforme proposta
              height: 100,
              width: 150,

              // cor herdada do tema principal
              color: Theme.of(context).primaryColor,

              // conteúdo interno (ícone + texto)
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  Text(
                    'Contacts',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
