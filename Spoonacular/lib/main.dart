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
            initialRoute: '/',
      routes: {
        '/': (context) => InicioPage(),
        '/search': (context) => PesquisarReceitasPage(),
        '/about': (context) => AboutPage(),
      }
    );
  }
}

class InicioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem vindo ao Aplicativo de Receitas!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
              child: Text('Pesquisar Receitas'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/about');
              },
              child: Text('Sobre'),
            ),
          ],
        ),
      ),
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
              'Ingredients:',
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

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Aplicaivo de Receitas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Desenvolvido por:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text('Daniel Leônidas de Medeiros'),
            Text('Sueliton dos Santos Medeiros'),
            Text('Vinicius Victor de Lima'),
          ],
        ),
      ),
    );
  }
}

