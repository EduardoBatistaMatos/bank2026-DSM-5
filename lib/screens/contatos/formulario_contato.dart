import 'package:flutter/material.dart';
import '../../components/editor.dart';
import '../../models/contato.dart';
import '../../db/app_database.dart';

class FormularioContato extends StatefulWidget {
  const FormularioContato({super.key});

  @override
  State<FormularioContato> createState() => _FormularioContatoState();
}

class _FormularioContatoState extends State<FormularioContato> {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorConta = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Contato')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Editor(
              controlador: _controladorNome,
              rotulo: 'Nome',
              dica: 'Ex: Maria Oliveira',
              icone: Icons.person,
            ),
            Editor(
              controlador: _controladorConta,
              rotulo: 'Número da conta',
              dica: '0000',
              icone: Icons.numbers,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                child: const Text('Salvar'),
                onPressed: () async {
                  final String nome = _controladorNome.text;
                  final int? conta = int.tryParse(_controladorConta.text);
                  if (nome.isNotEmpty && conta != null) {
                    final contatoCriado = Contato(
                      nome: nome,
                      numeroConta: conta,
                    );
                    final idGerado = await salvarContato(contatoCriado);
                    debugPrint('Contato salvo: id: $idGerado | nome: ${contatoCriado.nome}, conta: ${contatoCriado.numeroConta}');
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Preencha todos os campos corretamente.'),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
