import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:mission_sport/mesSeance.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  Map<String, dynamic> dataMap = {};
  Map<String, dynamic> seanceMap = {};

  bool _isLoading = false;
  bool recupDataBool = false;

  Future<Map<String, dynamic>> fetchUser(id) async {
    final response = await http.get(
        Uri.parse('https://s3-4680.nuage-peda.fr/missionSport/api/users/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }

  Future<void> recupDataJson() async {
    String id = dataMap['data']['id'].toString();
    var reponse = await fetchUser(id);
    seanceMap = reponse;
    recupDataBool = true;
  }

  startLoading() async {
    setState(() {
      _isLoading = true;
    });
    await recupDataJson();
    // si les données ont été récupéré
    if (recupDataBool) {
      // on navige vers MesSeancePage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MesSeancePage(
            title: 'Mes Seances',
          ),
          settings: RouteSettings(
            arguments: seanceMap,
          ),
        ),
      );
    } else {
      // sinon on affiche l'erreur et remet le booléen _isLoading à faux
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur dans la connection à la BDD"),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget afficheData() {
    Column contenu = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.empty(growable: true),
    );
    contenu.children.add(Text("Token: ${dataMap['token']}"));
    contenu.children.add(Text("Id: ${dataMap['data']['id']}"));

    return contenu;
  }

  @override
  Widget build(BuildContext context) {
    // recup l'argument passé dans le context précédent
    dataMap =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/exercice');
                  },
                  child: const Text("Les Exercices"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/seance');
                  },
                  child: const Text("Les séances"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  // selon la valeur de _isLoading, le bouton s'adapte
                  onPressed: _isLoading ? null : startLoading,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Mes séances"),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/createSeance',
                          arguments: dataMap);
                    },
                    child: const Text("Crée une séance"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// print(seanceMap["seances"][0]["detailSeances"][0]["exercice"]["nom"]);



