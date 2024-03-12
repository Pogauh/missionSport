import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class NewSeancePage extends StatefulWidget {
  const NewSeancePage({super.key, required String title});

  @override
  State<NewSeancePage> createState() => _NewSeancePageState();
}

class _NewSeancePageState extends State<NewSeancePage> {
  List<dynamic> cinqExercices = [];
  bool _isLoading = false;
  Map<String, dynamic> dataMap = {};
  //----------------------------

  String id = "";
  String exerciceId = "";
  String type = "";
  String txtButton = "Submit";
  bool recupDataBool = false;
  String date = "";
  Map<String, dynamic> seanceData = {};
  String idSeanceCreate = "";

  Future<http.Response> fetchDetailSeance(String exerciceId) {
    return http.post(
      Uri.parse(
          'https://s3-4680.nuage-peda.fr/missionSport/api/detail_seances'),
      headers: <String, String>{'Content-Type': 'application/ld+json'},
      body: convert.jsonEncode(
          <String, String>{'seance': idSeanceCreate, 'exercice': exerciceId}),
    );
  }

  Future<http.Response> fetchSeance(
      String id, String type, String formattedDate) {
    return http.post(
      Uri.parse('https://s3-4680.nuage-peda.fr/missionSport/api/seances'),
      headers: <String, String>{'Content-Type': 'application/ld+json'},
      body: convert
          .jsonEncode(<String, String>{'user': id, 'type': type, 'date': date}),
    );
  }

  Future<void> calcul() async {
    id = "/missionSport/api/users/${dataMap['data']['id']}";
    DateTime now = DateTime.now();
    date = now.toUtc().toIso8601String();
  }

  Future<void> recupDataJson() async {
    var reponse = await fetchSeance(id, type, date);
    if (reponse.statusCode == 201) {
      seanceData = json.decode(reponse.body);
      idSeanceCreate = seanceData['id'].toString();
      idSeanceCreate = "/missionSport/api/seances/$idSeanceCreate";

      recupDataBool = true;
    } else if (reponse.statusCode == 500) {
      print("erreur " + reponse.body.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Un probleme est survenue"),
        ),
      );
    } else {
      print("erreur " + reponse.body.toString());
    }
  }

  startLoading() async {
    setState(() {
      _isLoading = true;
      type = dataMap['data']['type'];
    });
    await calcul();
    await recupDataJson();
    if (recupDataBool) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("La séance a été créer"),
        ),
      );
      addExercice();
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

  addExercice() {
    for (int i = 0; i < cinqExercices.length; i++) {
      exerciceId = cinqExercices[i]['id'].toString();
      startLoadingExercice(exerciceId);
    }
  }

  //-----------------------------

  // Fonction qui attend fetchDetailSeance et qui veri
  //fie son resultat
  Future<void> recupDataJsonExercice(exerciceId) async {
    var reponse = await fetchDetailSeance(exerciceId);

    if (reponse.statusCode == 201) {
      recupDataBool = true;
    } else if (reponse.statusCode == 500) {
      print("erreur " + reponse.body.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Un probleme est survenue"),
        ),
      );
    } else {
      print("erreur " + reponse.body.toString());
    }
  }

  startLoadingExercice(String exerciceId) async {
    setState(() {
      exerciceId = '/missionSport/api/exercices/$exerciceId';
    });
    await recupDataJsonExercice(exerciceId);
    if (recupDataBool) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("L'exercice a été ajouter"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur dans l'ajout de l'exercice à la séance"),
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

  //------------------------------

  Widget buildPropositionList() {
    return ListView.builder(
      itemCount: cinqExercices.length,
      itemBuilder: (context, index) {
        // Récupérez la séance à l'index
        final exercice = cinqExercices[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  'Nom: ${exercice['nom']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description: ${exercice['description']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    dataMap =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    cinqExercices = dataMap['data']['cinqExercices'];
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
      body: Column(
        children: [
          Expanded(
            child: buildPropositionList(),
          ),
          Padding(
            padding: const EdgeInsets.all(45.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  // selon la valeur de _isLoading, le bouton s'adapte
                  onPressed: _isLoading ? null : startLoading,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Accepter la proposition"),
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
