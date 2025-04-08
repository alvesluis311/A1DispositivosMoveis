import 'package:flutter/material.dart';

void main() {
  runApp(ListaGamesApp());
}

class ListaGamesApp extends StatelessWidget {
  const ListaGamesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ListaGamesScaffold());
  }
}

class FormularioComprasScaffold extends StatelessWidget {
  final TextEditingController controllerNome = TextEditingController();
  final TextEditingController controllerQuantidade = TextEditingController();

  FormularioComprasScaffold({super.key});
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

class ListaGamesScaffoldState extends State<ListaGamesScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Games'),
        backgroundColor: Colors.black54,
      ),
      body: ListaGames(widget.listaGames),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioComprasScaffold();
          }));
          future.then((gameRecebido) {
            setState(() {
              widget.listaGames.add(gameRecebido);
            });
            print("Game Recebido: $gameRecebido");
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ListaGamesScaffold extends StatefulWidget {
  final List<Game> listaGames = [];

  @override
  State<ListaGamesScaffold> createState() {
    return ListaGamesScaffoldState();
  }
}

class ListaGames extends StatelessWidget {
  final List<Game> games;

  ListaGames(this.games);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        return ItemListaGames(games[index]);
      }, // Card
    );
  }
}

class ItemListaGames extends StatelessWidget {
  final Game game;

  const ItemListaGames(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(game.nome),
        subtitle: Text(game.quantidade.toString()),
        leading: Icon(Icons.games),
      ),
    );
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
