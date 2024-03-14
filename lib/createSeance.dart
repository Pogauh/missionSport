import 'dart:convert';
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
  List<dynamic> cinqExercices = [];
  Map reponse = {};
  Map<String, dynamic> dataMap = {};
  String type = "";

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

  Future<void> genereExoHcorps(reponse, seanceType) async {
    await recupDataJson();
    if (reponse.containsKey('hydra:member')) {
      final List<dynamic> exercicesJson = reponse['hydra:member'];
      exercicesJson.shuffle();
      List<Map<String, dynamic>> exercicesList = [];
      // Filtrer les exercices avec un muscleId différent de 2
      List<dynamic> filteredExercices = exercicesJson
          .where((exercice) => exercice['muscle']['id'] != 2)
          .toList();
      for (int i = 0; i < 5 && i < filteredExercices.length; i++) {
        Map<String, dynamic> exercice = {
          '@id': filteredExercices[i]['@id'],
          '@type': filteredExercices[i]['@type'],
          'id': filteredExercices[i]['id'],
          'nom': filteredExercices[i]['nom'],
          'description': filteredExercices[i]['description'],
        };
        exercicesList.add(exercice);
      }
      dataMap['data']['cinqExercices'] = exercicesList;
      dataMap['data']['type'] = type;
    }
  }

  Future<void> genereExoBCorps(reponse, seanceType) async {
    await recupDataJson();
    if (reponse.containsKey('hydra:member')) {
      final List<dynamic> exercicesJson = reponse['hydra:member'];
      int compareExercices(dynamic a, dynamic b) {
        int muscleIdA = a['muscle']['id'];
        int muscleIdB = b['muscle']['id'];
        return muscleIdA.compareTo(muscleIdB);
      }

      List exercicesList = exercicesJson
          .where((exercice) => exercice['muscle']['id'] == 2)
          .toList();

      // Trier la liste des exercices en utilisant la fonction de comparaison
      exercicesList.sort(compareExercices);
      exercicesList = exercicesList.take(5).toList();
      dataMap['data']['cinqExercices'] = exercicesList;
      dataMap['data']['type'] = type;
    }
  }

  Future<void> genereExoFullbody(reponse, seanceType) async {
    await recupDataJson();
    if (reponse.containsKey('hydra:member')) {
      final List<dynamic> exercicesJson = reponse['hydra:member'];
      exercicesJson.shuffle();
      List<Map<String, dynamic>> exercicesList = [];
      for (int i = 0; i < 5; i++) {
        Map<String, dynamic> exercice = {
          '@id': exercicesJson[i]['@id'],
          '@type': exercicesJson[i]['@type'],
          'id': exercicesJson[i]['id'],
          'nom': exercicesJson[i]['nom'],
          'description': exercicesJson[i]['description'],
        };
        exercicesList.add(exercice);
      }
      dataMap['data']['cinqExercices'] = exercicesList;
      dataMap['data']['type'] = type;
    }
  }

  startLoading(String seanceType) async {
    setState(() {
      _isLoading = true;
    });
    type = '/missionSport/api/types/$seanceType';
    await recupDataJson();

    if (seanceType == "3") {
      await genereExoFullbody(reponse, seanceType);
    } else if (seanceType == "2") {
      await genereExoHcorps(reponse, seanceType);
    } else if (seanceType == "1") {
      await genereExoBCorps(reponse, seanceType);
    }

    if (recupDataBool) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NewSeancePage(
            title: 'Nouvelle séance',
          ),
          settings: RouteSettings(
            arguments: dataMap,
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

  @override
  Widget build(BuildContext context) {
    dataMap =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Création"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/images/nav_MissionSport.png'),
            const SizedBox(height: 20),
            const Text(
              "Créer votre programme",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Par proposition",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _isLoading ? null : () => startLoading("2"),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Séance haut du corps"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : () => startLoading("1"),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Séance bas du corps"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : () => startLoading("3"),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Séance Fullbody"),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Manuellement ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateseancePersoPage(
                      title: 'Création de séance mannuel',
                    ),
                    settings: RouteSettings(
                      arguments: dataMap,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: const Text("Créer votre séance"),
            ),
          ],
        ),
      ),
    );
  }
}
