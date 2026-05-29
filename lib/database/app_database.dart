// pacote "path" fornece utilitários para manipular caminhos de arquivos de forma cross-platform (join, dirname, etc).
import 'package:path/path.dart';

// pacote sqflite: API para trabalhar com SQLite em Flutter/Dart.
import 'package:sqflite/sqflite.dart';
import '../models/transferencia.dart';
import 'dart:io';

Future<void> testarBanco() async {
  final String path = join(await getDatabasesPath(), 'bank.db');
  final File arquivoBanco = File(path);

  await deleteDatabase(path); // ativar quando for necessário apagar todo o banco

  // verifica se o arquivo existe
  final bool existe = await arquivoBanco.exists();

  if (existe) {
    print('****Banco de dados encontrado: $path');
    final Database db = await openDatabase(path);

    // consulta todas as tabelas
    final List<Map<String, dynamic>> tabelas =
        await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table';");

    if (tabelas.isNotEmpty) {
      print('****Tabelas encontradas:');
      for (var tabela in tabelas) {
        print('- ${tabela['name']}');
      }
    } else {
      print('****Nenhuma tabela encontrada no banco.');
    }

    await db.close();
  } else {
    print('XXXX - O arquivo do banco de dados não foi encontrado em: $path');
  }
}
// Função assíncrona que busca todas as transferências do banco de dados.
// Retorna um Future contendo uma lista de objetos Transferencia.
Future<List<Transferencia>> buscarTransferencias() async {

  // Obtém a instância do banco de dados (abre ou cria o DB se necessário).
  final Database db = await getDatabase();

  // Executa uma consulta (SELECT *) na tabela 'transferencias'.
  // O resultado é uma lista de Map<String, dynamic>, onde cada Map representa uma linha da tabela.
  final List<Map<String, dynamic>> result = await db.query('transferencias');

  // Converte a lista de Map<String, dynamic> em uma lista de objetos Transferencia.
  // List.generate cria uma lista com tamanho result.length e preenche usando a função fornecida.
  return List.generate(result.length, (i) {
    // Para cada índice 'i', cria um novo objeto Transferencia usando os valores da linha correspondente.
    return Transferencia(
      // Recupera o valor da coluna 'valor' da linha i.
      result[i]['valor'],
      // Recupera o valor da coluna 'numero_conta' da linha i.
      result[i]['numero_conta'],
    );
  });
}
// Função assíncrona que salva uma transferência no banco de dados.
// Retorna um Future<int> com o id da linha inserida.
Future<int> salvarTransferencia(Transferencia transferencia) async {

  // Obtém a instância do banco de dados (abre/cria o DB se necessário).
  final Database db = await getDatabase();

  // Cria um Map<String, dynamic> representando a transferência.
  // As chaves do Map devem corresponder aos nomes das colunas na tabela.
  final Map<String, dynamic> transferenciaMap = {
    // Atribui o valor da transferência à coluna 'valor'.
    'valor': transferencia.valor,
    // Atribui o número da conta à coluna 'numero_conta'.
    'numero_conta': transferencia.numeroConta,
  };

  // Insere o Map na tabela 'transferencias'.
  // O método db.insert retorna o id da linha inserida (auto-increment).
  return db.insert('transferencias', transferenciaMap);
}
// Função assíncrona que retorna um Future contendo uma instância de Database.
Future<Database> getDatabase() async {

  // Declara uma variável final chamada 'path' (String).
  // getDatabasesPath() retorna o diretório onde DBs devem ser salvos (plataforma específica) — usamos await porque é Future.
  // join(...) concatena o diretório com o nome do arquivo 'bank.db' usando o separador correto para o SO.
  final String path = join(await getDatabasesPath(), 'bank.db');

  // openDatabase abre (ou cria) o banco de dados no caminho fornecido e retorna um Future<Database>.
  return openDatabase(
    // caminho do arquivo do banco (ex: /data/user/0/.../databases/bank.db).
    path,

    // callback executado apenas quando o arquivo do DB não existe e precisa ser criado.
    onCreate: (db, version) async {
      // executa a instrução SQL para criar a tabela 'transferencias' com id auto-increment.
      await db.execute('CREATE TABLE transferencias('
          // coluna 'id' do tipo INTEGER, chave primária e auto-incrementada.
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          // coluna 'valor' do tipo REAL (número de ponto flutuante).
          'valor REAL, '
          // coluna 'numero_conta' do tipo INTEGER — fecha a declaração CREATE TABLE.
          'numero_conta INTEGER)');
    },

    // versão do esquema do banco. Usada para controlar migrations (onUpgrade/onDowngrade).
    version: 1,
  );
}