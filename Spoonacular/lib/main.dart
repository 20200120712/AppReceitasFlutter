import 'package:flutter/material.dart';


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
/////////////////////////////////////////////////////