import 'package:flutter/material.dart';

void main() {
  runApp(ListaGamesApp());
}

class ListaGamesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ListaGamesScaffold());
  }
}

class FormularioComprasScaffold extends StatelessWidget {
  final TextEditingController controllerNome = TextEditingController();
  final TextEditingController controllerQuantidade = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Games'),
        backgroundColor: Colors.black54,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: controllerNome,
              decoration: InputDecoration(
                  labelText: "Nome do Game",
                  hintText: "Exemplo: Split Fiction..."),
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controllerQuantidade,
              decoration: InputDecoration(
                  labelText: "Quantidade do Game", hintText: "Exemplo: 50..."),
              style: TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                String nome = controllerNome.text;
                int quantidade = int.parse(controllerQuantidade.text);
                Game game = Game(nome, quantidade);
                Navigator.pop(context, game);
                print(game);
              },
              child: Text('SALVAR'))
        ],
      ),
    );
  }
}

class ListaGamesScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Games'),
        backgroundColor: Colors.black54,
      ),
      body: ListaGames(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioComprasScaffold();
          }));
          future.then((gameRecebido) {
            print("Game Recebido: $gameRecebido");
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ListaGames extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemListaGames(Game("Hollow Knight", 5)),
        ItemListaGames(Game("Baldur\'s Gate 3", 4)),
        ItemListaGames(Game("Elden Ring", 7)),
      ],
    );
  }
}

class ItemListaGames extends StatelessWidget {
  final Game game;

  ItemListaGames(this.game);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(game.nome),
        subtitle: Text(game.quantidade.toString()),
        leading: Icon(Icons.gamepad),
      ), // ListTile
    ); // Card
  }
}

class Game {
  String nome;
  int quantidade;

  Game(this.nome, this.quantidade);

  @override
  String toString() {
    return 'Game{nome: $nome, quantidade: $quantidade}';
  }
}
