import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:mission_sport/createSeancePerso.dart';
import 'package:mission_sport/newSeance.dart';

class CreateSeancePage extends StatefulWidget {
  const CreateSeancePage({super.key, required String title});

  @override
  State<CreateSeancePage> createState() => _CreateSeancePageState();
}

class _CreateSeancePageState extends State<CreateSeancePage> {
  bool _isLoading = false;
  bool recupDataBool = false;
  bool calcul = false;
  List<dynamic> deuxExercices = [];
  Map reponse = {};
  Map<String, dynamic> dataMap = {};

  static Future<Map<String, dynamic>> fetchExercice() async {
    final response = await http.get(
        Uri.parse('https://s3-4680.nuage-peda.fr/missionSport/api/exercices'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }

  Future<void> recupDataJson() async {
    reponse = await fetchExercice();
    recupDataBool = true;
  }

  Future<void> genereExo(reponse) async {
    await recupDataJson();
    if (reponse.containsKey('hydra:member')) {
      final List<dynamic> exercicesJson = reponse['hydra:member'];
      final Random random = Random();

      // Mélangez la liste des exercices
      exercicesJson.shuffle();
      deuxExercices = exercicesJson.take(2).toList();
    }
  }

  startLoading() async {
    setState(() {
      _isLoading = true;
    });
    await recupDataJson();
    await genereExo(reponse);
    // si les données ont été récupéré
    if (recupDataBool) {
      // on navige vers MesSeancePage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NewSeancePage(
            title: 'Nouvelle séance',
          ),
          settings: RouteSettings(
            arguments: deuxExercices,
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

  @override
  Widget build(BuildContext context) {
    dataMap =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Créer votre programme",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Faites quelque chose lorsque le bouton est pressé
                  },
                  child: Text("Séance haut du corps"),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Faites quelque chose lorsque le bouton est pressé
                  },
                  child: Text("Séance bas du corps"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : startLoading,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Séance Fullbody"),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateseancePersoPage(
                          title: 'Mes Seances',
                        ),
                        settings: RouteSettings(
                          arguments: dataMap,
                        ),
                      ),
                    );
                  },
                  child: Text("Créer votre séance"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
