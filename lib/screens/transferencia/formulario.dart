import 'package:bank/database/app_database.dart';
import 'package:flutter/material.dart';
import '../../components/editor.dart';
import '../../models/transferencia.dart';
import 'package:intl/intl.dart';

class FormularioTransferencia extends StatefulWidget {
  final TextEditingController _controladorCampoNumeroConta =
      TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  @override
  State<StatefulWidget> createState() {
    return FormularioTransferenciaState();
  }
}

class FormularioTransferenciaState extends State<FormularioTransferencia> {
  final TextEditingController _controladorCampoNumeroConta =
      TextEditingController();

  final TextEditingController _controladorCampoValor = TextEditingController();

  static const _tituloAppBar = 'Criando transferência';
  static const _rotuloCampoValor = 'Valor';
  static const _dicaCampoValor = '0,00';
  static const _rotuloCampoNumeroConta = 'Número da Conta';
  static const _dicaCampoNumeroConta = '00000';

// Função que cria uma nova transferência a partir dos campos de texto do formulário
// Recebe o BuildContext (para navegar de volta) e os controladores de texto
void _criaTransferencia(
  BuildContext context,
  TextEditingController controladorCampoNumeroConta,
  TextEditingController controladorCampoValor,
) {

  // Converte o texto do campo "Número da Conta" em int, retorna null se não for válido
  final int? numeroConta = int.tryParse(controladorCampoNumeroConta.text);

  // Converte o texto do campo "Valor" em double, retorna null se não for válido
  final double? valor = double.tryParse(controladorCampoValor.text);

  // Só prossegue se ambos os valores forem válidos
  if (numeroConta != null && valor != null) {

    // Cria um objeto Transferencia com os dados fornecidos
    final transferenciaCriada = Transferencia(valor, numeroConta);

    // Salva a transferência no banco de dados (assíncrono)
    // .then() é chamado quando a inserção é concluída
    salvarTransferencia(transferenciaCriada).then((id) {
      // Mostra no console o id gerado pelo SQLite (auto-increment)
      debugPrint('Transferência salva com id: $id');

      // Retorna à tela anterior e passa a transferência criada de volta
      // Isso permite atualizar a lista de transferências na tela anterior
      Navigator.pop(context, transferenciaCriada);
    });
  }
}

  
  @override
  Widget build(BuildContext context) {
    String _textBotaoConfirmar = 'Confirmar';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tituloAppBar,
          // style: TextStyle(
          //   color: Colors.white70,
          //   fontSize: 20,
          //   fontWeight: FontWeight.bold,
          // ),
        ),
        //backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
              controlador: widget._controladorCampoNumeroConta,
              rotulo: _rotuloCampoNumeroConta,
              dica: _dicaCampoNumeroConta,
            ),

            Editor(
              controlador: widget._controladorCampoValor,
              rotulo: _rotuloCampoValor,
              dica: _dicaCampoValor,
              icone: Icons.monetization_on,
            ),

            ElevatedButton(
              child: Text(_textBotaoConfirmar),
              onPressed: () {
                debugPrint("Clicou no Confirmar!");
                _criaTransferencia(
                  context,
                  widget._controladorCampoNumeroConta,
                  widget._controladorCampoValor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void _criaTransferencia(
  BuildContext context,
  TextEditingController controladorCampoNumeroConta,
  TextEditingController controladorCampoValor,
) {
  final int? numeroConta = int.parse(controladorCampoNumeroConta.text);
  final double? valor = double.parse(controladorCampoValor.text);

  if (numeroConta != null && valor != null) {
    final transferenciaCriada = Transferencia(valor, numeroConta);
    debugPrint("Criando Transferência...");
    debugPrint("$transferenciaCriada");
    Navigator.pop(context, transferenciaCriada);
  }
}