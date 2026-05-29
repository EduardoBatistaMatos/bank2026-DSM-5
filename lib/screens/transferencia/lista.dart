import 'package:flutter/material.dart';
import 'formulario.dart';
import '../../models/transferencia.dart';
import 'package:intl/intl.dart';
import "../../database/app_database.dart"; // fazer esse import do db

class ListaTransferencias extends StatefulWidget {
  final List<Transferencia> _transferencias = [];
  @override
  State<StatefulWidget> createState() {
    return ListaTranferenciaState();
  }
}

class ListaTranferenciaState extends State<ListaTransferencias> {
  static const _tituloAppBar = 'Transferência';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tituloAppBar,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
      ),

      // Importa o helper do banco de dados, para usar funções como getDatabase() e buscarTransferencias()

// Widget que constrói a interface baseada no resultado de um Future.
// Nesse caso, a lista de transferências vindas do banco.
body: FutureBuilder<List<Transferencia>>(
  
  // Future que será executado para obter os dados.
  // Aqui chamamos a função buscarTransferencias() que retorna Future<List<Transferencia>>
  future: buscarTransferencias(),

  // Função builder que recebe o contexto e o snapshot (resultado do Future)
  builder: (context, snapshot) {

    // Verifica se o Future ainda está em execução
    // ConnectionState.waiting indica que a operação assíncrona não terminou
    if (snapshot.connectionState == ConnectionState.waiting) {
      // Mostra um indicador de progresso centralizado enquanto os dados carregam
      return Center(child: CircularProgressIndicator());
    }

    // Verifica se ocorreu algum erro durante a execução do Future
    if (snapshot.hasError) {
      // Mostra uma mensagem de erro centralizada
      return Center(child: Text('Erro ao carregar transferências'));
    }

    // Verifica se não há dados ou se a lista retornada está vazia
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      // Mostra uma mensagem indicando que não há transferências
      return Center(child: Text('Nenhuma transferência encontrada'));
    }

    // Se chegou aqui, significa que há dados válidos no snapshot
    // Recupera a lista de transferências
    final transferencias = snapshot.data!;

    // Cria uma ListView dinâmica para mostrar cada transferência
    return ListView.builder(
      // Define a quantidade de itens com base no tamanho da lista
      itemCount: transferencias.length,

      // Função que constrói cada item da lista
      itemBuilder: (context, indice) {
        // Pega a transferência correspondente ao índice atual
        final transferencia = transferencias[indice];

        // Retorna o widget que representa visualmente a transferência
        // (supondo que ItemTransferencia é um widget customizado)
        return ItemTransferencia(transferencia);
      },
    );
  },
),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Botão + Pressionado!");

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return FormularioTransferencia();
              },
            ),
          ).then((transferenciaRecebida) => _atualiza(transferenciaRecebida));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _atualiza(Transferencia? transferenciaRecebida) {
    if (transferenciaRecebida != null) {
      setState(() {
        widget._transferencias.add(transferenciaRecebida);
      });
    }
  }
}

class ItemTransferencia extends StatelessWidget {
  // Campos para armazenar os dados do item
  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    NumberFormat formato = NumberFormat.simpleCurrency();
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(formato.format(_transferencia.valor).toString()),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}
