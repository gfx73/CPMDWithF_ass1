import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chuck jokes',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      )),
      home: const ChuckJokes(),
    );
  }
}

class ChuckJokes extends StatefulWidget {
  const ChuckJokes({Key? key}) : super(key: key);

  @override
  _ChuckJokesState createState() => _ChuckJokesState();
}

class AboutMe extends StatelessWidget {
  const AboutMe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
            child: Container(
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'About',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ))),
        Align(
            alignment: Alignment.topLeft,
            child: Container(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                child: const Text(
                  "My name is Aidar Khuzin. I'm third year bachelor student of Innopolis University.",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ))),
        Align(
            alignment: Alignment.topLeft,
            child: Container(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                child: const Text(
                  "This app was created as CPMDWithF course first assignment",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ))),
        Align(
            alignment: Alignment.topLeft,
            child: Container(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                child: const Text(
                  "My contacts:",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ))),
        Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                    child: const Text(
                      "Mail: ",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )),
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                    child: const SelectableText(
                      "ay.khuzin@innopolis.university",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue
                      ),
                    ))
              ],
            )
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Container(
                    padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                    child: const Text(
                      "Telegram: ",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )),
                Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                    child: const SelectableText(
                      "@gsabf",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue
                      ),
                    ))
              ],
            )
        ),
      ],
    );
  }
}

class _ChuckJokesState extends State<ChuckJokes> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Chuck jokes');
  int _bottomNavBarI = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const RandomJokes(),
    const Categories(),
    const AboutMe()
  ];

  void _onBottomNavBarItemTapped(int index) {
    setState(() {
      _bottomNavBarI = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (customIcon.icon == Icons.search) {
                  customIcon = const Icon(Icons.cancel);
                  customSearchBar = ListTile(
                    leading: const Icon(
                      Icons.search,
                    ),
                    title: TextField(
                      decoration: const InputDecoration(
                        hintText: 'type something about joke',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (String query) {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (context) {
                            return SafeArea(
                              child: Scaffold(
                                appBar: AppBar(
                                  title: const Text('Search results'),
                                ),
                                body: SearchJokes(query: query),
                              ),
                            );
                          },
                        ));
                      },
                    ),
                  );
                } else {
                  customIcon = const Icon(Icons.search);
                  customSearchBar = const Text('Chuck jokes');
                }
              });
            },
            icon: customIcon,
          )
        ],
      ),
      body: _widgetOptions[_bottomNavBarI],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Random jokes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'About me',
          ),
        ],
        currentIndex: _bottomNavBarI,
        // selectedItemColor: Colors.amber[800],
        onTap: _onBottomNavBarItemTapped,
      ),
    ));
  }
}

class RandomJokes extends StatefulWidget {
  const RandomJokes({Key? key}) : super(key: key);

  @override
  _RandomJokesState createState() => _RandomJokesState();
}

class _RandomJokesState extends State<RandomJokes> {
  final _jokes = <FutureBuilder<Joke>>[];

  Future<Joke> _getRandomJoke() async {
    final response =
        await http.get(Uri.parse('https://api.chucknorris.io/jokes/random'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Joke.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load joke');
    }
  }

  Widget _buildRow(FutureBuilder<Joke> joke) {
    return ListTile(title: joke);
  }

  Widget _buildJokes() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return const Divider();
        }

        final index = i ~/ 2;
        if (index >= _jokes.length) {
          for (int i = 0; i < 10; i++) {
            _jokes.add(FutureBuilder<Joke>(
              future: _getRandomJoke(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.value);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              },
            ));
          }
        }
        return _buildRow(_jokes[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildJokes();
  }
}

class Joke {
  final String value;

  const Joke({required this.value});

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(value: json['value']);
  }
}

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  static Future<CategoriesList> _getCategories() async {
    final response = await http
        .get(Uri.parse('https://api.chucknorris.io/jokes/categories'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return CategoriesList.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load categories');
    }
  }

  Widget _buildCategories() {
    return FutureBuilder<CategoriesList>(
      future: _getCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final _categories = ListTile.divideTiles(
              context: context,
              tiles: snapshot.data!.data.map(
                (category) {
                  return ListTile(
                    title: Text(category),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (context) {
                          return SafeArea(
                            child: Scaffold(
                                appBar: AppBar(
                                  title: Text(category),
                                ),
                                body: JokesByCategory(category: category)),
                          );
                        },
                      ));
                    },
                  );
                },
              ));
          return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _categories.length,
              itemBuilder: (context, i) {
                return _categories.elementAt(i);
              });
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCategories();
  }
}

class CategoriesList {
  final List<String> data;

  const CategoriesList({required this.data});

  factory CategoriesList.fromJson(List<dynamic> json) {
    return CategoriesList(data: json.cast<String>());
  }
}

class JokesByCategory extends StatefulWidget {
  final String category;

  const JokesByCategory({Key? key, required this.category}) : super(key: key);

  @override
  _JokesByCategoryState createState() => _JokesByCategoryState();
}

class _JokesByCategoryState extends State<JokesByCategory> {
  final _jokes = <FutureBuilder<Joke>>[];
  late String _category;

  @override
  void initState() {
    super.initState();
    _category = widget.category;
  }

  Future<Joke> _getJoke() async {
    final response = await http.get(Uri.parse(
        'https://api.chucknorris.io/jokes/random?category=$_category'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Joke.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load joke');
    }
  }

  Widget _buildRow(FutureBuilder<Joke> joke) {
    return ListTile(title: joke);
  }

  Widget _buildJokes() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return const Divider();
        }

        final index = i ~/ 2;
        if (index >= _jokes.length) {
          for (int i = 0; i < 10; i++) {
            _jokes.add(FutureBuilder<Joke>(
              future: _getJoke(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.value);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              },
            ));
          }
        }
        return _buildRow(_jokes[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildJokes();
  }
}

class SearchJokes extends StatefulWidget {
  final String query;

  const SearchJokes({Key? key, required this.query}) : super(key: key);

  @override
  _SearchJokesState createState() => _SearchJokesState();
}

class _SearchJokesState extends State<SearchJokes> {
  late String _query;

  Future<List<String>> _getJokes() async {
    final response = await http.get(
        Uri.parse('https://api.chucknorris.io/jokes/search?query=$_query'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(response.body)['result']
          .map((el) {
            return el['value'];
          })
          .toList()
          .cast<String>();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load joke');
    }
  }

  Widget _buildJokes() {
    return FutureBuilder<List<String>>(
      future: _getJokes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final _jokes = ListTile.divideTiles(
              context: context,
              tiles: snapshot.data!.map(
                (joke) {
                  return ListTile(
                    title: Text(joke),
                  );
                },
              ));
          return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _jokes.length,
              itemBuilder: (context, i) {
                return _jokes.elementAt(i);
              });
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _query = widget.query;
  }

  @override
  Widget build(BuildContext context) {
    return _buildJokes();
  }
}
