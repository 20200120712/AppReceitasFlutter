import 'package:flutter/material.dart';
import 'recipe_api.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receitas Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PesquisarReceitasPage(),
    );
  }
}

class PesquisarReceitasPage extends StatefulWidget {
  @override
  _PesquisarReceitasPageState createState() => _PesquisarReceitasPageState();
}

class _PesquisarReceitasPageState extends State<PesquisarReceitasPage> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _recipes = [];

  void _searchRecipes() async {
    String query = _searchController.text;
    List<dynamic> recipes = await RecipeApi.searchRecipes(query);
    setState(() {
      _recipes = recipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesquisar Receitas'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar Receitas',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchRecipes,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_recipes[index]['title']),
                  onTap: () async {
                    Map<String, dynamic> recipeDetails =
                        await RecipeApi.getRecipeDetails(_recipes[index]['id']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DescreverReceitasPage(recipeDetails),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DescreverReceitasPage extends StatelessWidget {
  final Map<String, dynamic> recipeDetails;

  DescreverReceitasPage(this.recipeDetails);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeDetails['title']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(recipeDetails['image']),
            SizedBox(height: 16),
            Text(
              'Ingredientes:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: recipeDetails['extendedIngredientes'].length,
                itemBuilder: (context, index) {
                  return Text('- ${recipeDetails['extendedIngredientes'][index]['original']}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
