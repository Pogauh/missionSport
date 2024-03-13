import 'dart:convert';
import 'dart:ffi';

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
      throw Exception('Failed to load data. Status code: ${response.body}');
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
    dataMap =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              }),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/images/nav_MissionSport.png'),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/exercice');
              },
              child: const Text(
                "Les Exercices",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              // selon la valeur de _isLoading, le bouton s'adapte
              onPressed: _isLoading ? null : startLoading,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Mes séances",
                      style: TextStyle(fontSize: 20),
                    ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/createSeance',
                    arguments: dataMap);
              },
              child: const Text(
                "Crée une séance",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
