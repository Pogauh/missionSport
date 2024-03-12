import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:mission_sport/api/api_exercice.dart';

class AddExerciceSeancePage extends StatefulWidget {
  const AddExerciceSeancePage({Key? key, required this.title})
      : super(key: key);

  final String title;

  @override
  State<AddExerciceSeancePage> createState() => _AddExerciceSeancePageState();
}

class _AddExerciceSeancePageState extends State<AddExerciceSeancePage> {
  String exerciceId = "";
  String seanceId = "";
  bool recupDataBool = false;
  Map<String, dynamic>? _exercicesData;
  List<dynamic>? _filteredExercices;
  TextEditingController _nomController = TextEditingController();

  @override
  // initie la récupération des exercice
  void initState() {
    super.initState();
    fetchExercice();
  }

  // Récupération des exercices
  fetchExercice() async {
    try {
      final exercicesData = await GetExercice.fetchExercice();
      setState(() {
        _exercicesData = exercicesData;
        _filteredExercices = _exercicesData!['hydra:member'];
      });
    } catch (e) {
      print('Error fetching users data: $e');
    }
  }

  // fonction pour rechercher les exercices
  void _searchExercices() {
    if (_exercicesData != null) {
      // Variables qui prend en compte les ecritures du champ de recherche
      final String nomQuery = _nomController.text.toLowerCase();

      setState(() {
        _filteredExercices = _exercicesData!['hydra:member'].where((exercice) {
          final String nom = exercice['nom']?.toString().toLowerCase() ?? '';

          // Conditions que les variables doivent respecter pour être inclure
          // l'exercice dans la liste envoyé à FilteredExercices
          return nom.contains(nomQuery);
        }).toList();
      });
    }
  }

  Widget buildExerciceList() {
    if (_filteredExercices == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _filteredExercices!.length,
      itemBuilder: (context, index) {
        final exercice = _filteredExercices![index];
        return InkWell(
          onTap: () {
            startLoading(exercice['id'].toString());
          },
          child: Card(
            margin: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Nom: ${exercice['nom']}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Description: ${exercice['description']}',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Méthode qui ajoute l'exercice
  Future<http.Response> fetchDetailSeance(String seanceId, String exerciceId) {
    return http.post(
      Uri.parse(
          'https://s3-4680.nuage-peda.fr/missionSport/api/detail_seances'),
      headers: <String, String>{'Content-Type': 'application/ld+json'},
      body: convert.jsonEncode(
          <String, String>{'seance': seanceId, 'exercice': exerciceId}),
    );
  }

  // Fonction qui attend fetchDetailSeance et qui verifie son resultat
  Future<void> recupDataJson(exerciceId) async {
    var reponse = await fetchDetailSeance(seanceId, exerciceId);
    print("l'id de la seance $seanceId et lexo est $exerciceId");

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
      print("erreur " + reponse.statusCode.toString());
    }
  }

  // Fonction déclanché par le clique qui attend recupDataJson et annonce son resultat
  startLoading(String exerciceId) async {
    setState(() {
      exerciceId = '/missionSport/api/exercices/$exerciceId';
      print(exerciceId);
    });
    await recupDataJson(exerciceId);
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
      setState(() {});
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    seanceId = ModalRoute.of(context)?.settings.arguments as String;
    seanceId = "/missionSport/api/seances/$seanceId";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _nomController,
                onChanged: (_) => _searchExercices(),
                decoration: const InputDecoration(
                  hintText: 'Nom',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
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
            child: buildExerciceList(),
          ),
        ],
      ),
    );
  }
}
