import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeApi {
  static const apiKey = '661a1fcdefcc46869e5c0a8e61a7a8a2';

  static Future<List<dynamic>> searchRecipes(String query) async {
    final apiUrl = 'https://api.spoonacular.com/recipes/complexSearch';
    final parameters = {
      'apiKey': apiKey,
      'query': query,
      'number': '5',
    };

    final uri = Uri.parse(apiUrl).replace(queryParameters: parameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception('Falha ao pesquisar receitas');
    }
  }

  static Future<Map<String, dynamic>> getRecipeDetails(int recipeId) async {
    final apiUrl = 'https://api.spoonacular.com/recipes/$recipeId/information';
    final parameters = {'apiKey': apiKey};

    final uri = Uri.parse(apiUrl).replace(queryParameters: parameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Falha ao descrever receitas');
    }
  }
}
