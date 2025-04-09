import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://67f6d50c42d6c71cca636c42.mockapi.io/ap1/v1/games';

  // Buscar todos os jogos
  Future<List<Game>> getGames() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Game.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar jogos');
    }
  }

  // Criar um novo jogo
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
    print('Enviando game: ${json.encode({
      'nome': game.nome,
      'quantidade': game.quantidade,
      'preco': game.preco,
    })}');

    if (response.statusCode == 201) {
      return Game.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao criar jogo: ${response.statusCode} ${response.body}');
    }
  }


  // Atualizar um jogo
  Future<Game> updateGame(Game game) async {
    final url = Uri.parse('$baseUrl/${game.id}');
    final body = json.encode(game.toJson());

    print(">>> Atualizando game ${game.id} na URL: $url");
    print(">>> Corpo enviado: $body");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print(">>> Status Code: ${response.statusCode}");
    print(">>> Body da resposta: ${response.body}");

    if (response.statusCode == 200) {
      return Game.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao atualizar jogo: ${response.statusCode} ${response.body}');
    }
  }


  // Deletar um jogo
  Future<void> deleteGame(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar jogo');
    }
  }
}

// Modelo de Game
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
