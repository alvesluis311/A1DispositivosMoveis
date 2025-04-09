import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Game {
  String id;
  String nome;
  int quantidade;
  double preco;

  Game({required this.id, required this.nome, required this.quantidade, required this.preco});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      nome: json['nome'],
      quantidade: json['quantidade'],
      preco: (json['preco'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'quantidade': quantidade,
      'preco': preco,
    };
  }
}

const String baseUrl = 'https://67f6d50c42d6c71cca636c42.mockapi.io/ap1/v1/games';

Future<List<Game>> getGames() async {
  final response = await http.get(Uri.parse(baseUrl));
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Game.fromJson(json)).toList();
  } else {
    throw Exception('Erro ao carregar jogos');
  }
}

Future<Game> createGame(Game game) async {
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: {"Content-Type": "application/json"},
    body: json.encode({
      'nome': game.nome,
      'quantidade': game.quantidade,
      'preco': game.preco,
    }),
  );

  if (response.statusCode == 201) {
    return Game.fromJson(json.decode(response.body));
  } else {
    throw Exception('Erro ao criar jogo: ${response.statusCode} ${response.body}');
  }
}

Future<Game> updateGame(Game game) async {
  final url = Uri.parse('$baseUrl/${game.id}');
  final response = await http.put(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(game.toJson()),
  );
  if (response.statusCode == 200) {
    return Game.fromJson(json.decode(response.body));
  } else {
    throw Exception('Erro ao atualizar jogo: ${response.statusCode} ${response.body}');
  }
}

Future<void> deleteGame(String id) async {
  final response = await http.delete(Uri.parse('$baseUrl/$id'));
  if (response.statusCode != 200) {
    throw Exception('Erro ao deletar jogo');
  }
}


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

class FormularioComprasScaffold extends StatefulWidget {
  final Game? game;
  final Function(Game)? onSave;

  FormularioComprasScaffold({super.key, this.game, this.onSave});

  @override
  State<FormularioComprasScaffold> createState() => _FormularioComprasScaffoldState();
}

class _FormularioComprasScaffoldState extends State<FormularioComprasScaffold> {
  final TextEditingController controllerNome = TextEditingController();
  final TextEditingController controllerQuantidade = TextEditingController();
  final TextEditingController controllerPreco = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.game != null) {
      controllerNome.text = widget.game!.nome;
      controllerQuantidade.text = widget.game!.quantidade.toString();
      controllerPreco.text = widget.game!.preco.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game == null ? 'Cadastro de Games' : 'Editar Game'),
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
              keyboardType: TextInputType.number,
            ),
          ),Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controllerPreco,
              decoration: InputDecoration(
                  labelText: "Preço do Game", hintText: "Exemplo: 25.0"),
              style: TextStyle(fontSize: 16),
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(
              onPressed: () {
                String nome = controllerNome.text;
                int quantidade = int.parse(controllerQuantidade.text);
                double preco = double.parse(controllerPreco.text);
                Game game = Game(
                  id: widget.game?.id ?? '',
                  nome: nome,
                  quantidade: quantidade,
                  preco: preco,
                );
                widget.onSave?.call(game);
                Navigator.pop(context);
              },

              child: Text('SALVAR'))
        ],
      ),
    );
  }
}

class ListaGamesScaffoldState extends State<ListaGamesScaffold> {
  List<Game> games = [];

  @override
  void initState() {
    super.initState();
    carregarGames();
  }

  @override
  void carregarGames() async {
    try {
      List<Game> lista = await getGames();
      setState(() {
        games = lista;
      });
    } catch (e) {
      print("Erro ao carregar jogos: $e");
    }
  }

  void adicionarGame(Game game) async {
    try {
      Game novoGame = await createGame(game);
      setState(() {
        games.add(novoGame);
      });
    } catch (e) {
      print("Erro ao adicionar jogo: $e");
    }
  }

  void editarGame(int index, Game gameEditado) async {
    try {
      Game atualizado = await updateGame(gameEditado);
      setState(() {
        games[index] = atualizado;
      });
    } catch (e) {
      print("Erro ao atualizar jogo: $e");
    }
  }

  void deletarGame(int index) async {
    try {
      await deleteGame(games[index].id);
      setState(() {
        games.removeAt(index);
      });
    } catch (e) {
      print("Erro ao deletar jogo: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Games'),
        backgroundColor: Colors.black54,
      ),
      body: ListaGames(games, deletarGame, editarGame),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioComprasScaffold(
              onSave: (game) {
                adicionarGame(game);
              },
            );
          }));
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
  final Function(int) onDelete;
  final Function(int, Game) onEdit;

  ListaGames(this.games, this.onDelete, this.onEdit);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        return ItemListaGames(games[index],
            onDelete: () => onDelete(index),
            onEdit: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FormularioComprasScaffold(
                  game: games[index],
                  onSave: (gameEditado) => onEdit(index, gameEditado),
                );
              }));
            });
      },
    );
  }
}

class ItemListaGames extends StatelessWidget {
  final Game game;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ItemListaGames(this.game, {super.key, required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(game.nome),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Quantidade: ${game.quantidade.toString()}"),
            Text(
              "R\$: ${game.preco.toString()}",
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        leading: Icon(Icons.games),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.lightBlue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
