import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class AccueilPage extends StatefulWidget {
  const AccueilPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  Map<String, dynamic> dataMap = new Map();

  Widget afficheData() {
    Column contenu = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.empty(growable: true),
    );
    contenu.children.add(Text("Token: " + dataMap['token'].toString()));
    contenu.children.add(Text("Id: " + dataMap['data']['id'].toString()));

    return contenu;
  }

  @override
  Widget build(BuildContext context) {
    // recup l'argument passé dans le context précédent
    dataMap =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // l'icon permet de fermer le context en cours et tout les précédents (empilé via des push)
                // et nous ouvre le context correspondant à l'écran de login
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              }),
        ],
      ),
      body: Column(
        children: [
          Center(child: afficheData()),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/exercice');
            },
            child: Text("Les Exercices"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/seance');
            },
            child: Text("Les séances"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/mesSeance', arguments: dataMap);
            },
            child: Text("Les séances perso"),
          ),
        ],
      ),
    );
  }
}

class ExerciceApi {
  static Future<Map<String, dynamic>> fetchExercice() async {
    final response = await http.get(
        Uri.parse('https://s3-4680.nuage-peda.fr/missionSport/api/exercice'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }
}
