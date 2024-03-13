import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mission_sport/ModifExercice.dart';
import 'package:http/http.dart' as http;
import 'package:mission_sport/detailExercice.dart';

class MesExoSeancePage extends StatefulWidget {
  const MesExoSeancePage({Key? key, required this.seance}) : super(key: key);
  final dynamic seance;

  @override
  _MesExoSeancePageState createState() => _MesExoSeancePageState();
}

class _MesExoSeancePageState extends State<MesExoSeancePage> {
  String seanceId = "";
  int detailSeanceId = 0;
  String exercice = "";
  calcul() {
    seanceId = widget.seance["id"].toString();
  }

  Future<void> _navigateToEditPage(dynamic detailSeance) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ModifExercicePage(detailSeance: detailSeance)),
    );
  }

  Future<void> _navigateToExoDetailPage(dynamic exercice) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailExercicePage(exercice: exercice)),
    );
  }

  suppDetailSeance(detailSeance) {
    detailSeanceId = detailSeance['id'];
    deleteDetailSeance(detailSeanceId);
  }

  voir(detailSeance) {
    exercice = detailSeance['exercice'].toString();
    print(exercice);
    _navigateToExoDetailPage(exercice);
  }

  Future<void> deleteDetailSeance(int detailSeanceId) async {
    final response = await http.delete(
      Uri.parse(
          'https://s3-4680.nuage-peda.fr/missionSport/api/detail_seances/$detailSeanceId'),
      headers: <String, String>{
        'Content-Type': 'application/merge-patch+json',
      },
    );
    if (response.statusCode == 204) {
      print("La suppression a correctement été effectuée");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("La suppression de l'exercice a correctement été effectuée"),
        ),
      );
    } else {
      print('Reponse.body.toString = ' + response.body.toString());
    }
  }

  Widget buildExoList() {
    // Vérifiez si la clé "detailSeances" existe dans seance
    if (widget.seance.containsKey("detailSeances")) {
      // Récupérez la liste de détail des séances
      List<dynamic>? detailSeances = widget.seance["detailSeances"];

      // Vérifiez si la liste de détail des séances est non nulle et a au moins 1 élément
      if (detailSeances != null && detailSeances.isNotEmpty) {
        return ListView.builder(
          itemCount: detailSeances.length,
          itemBuilder: (context, index) {
            // Récupérez le détail de la séance à l'index donné
            final detailSeance = detailSeances[index];
            detailSeance['seanceId'] = seanceId;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Couleur grise légère
                  borderRadius: BorderRadius.circular(
                      8.0), // Facultatif : ajouter des coins arrondis
                ),
                child: InkWell(
                  onTap: () => _navigateToEditPage(detailSeance),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '${index + 1}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                              child: Column(
                            children: [
                              Text(
                                'Exercice: ${detailSeance['exercice']['nom']}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                'Series: ${detailSeance['sets'] ?? "Aucune données écrite"}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                'Répétitions: ${detailSeance['repetition'] ?? "Aucune données écrite"}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                'Commentaire: ${detailSeance['commentaire'] ?? "Aucun commentaire écrit"}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          suppDetailSeance(detailSeance),
                                      style: ElevatedButton.styleFrom(
                                        textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      child: const Text("Supprimer l'exercice"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () => voir(detailSeance),
                                      style: ElevatedButton.styleFrom(
                                        textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      child: const Text("Voir l'exercice"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    }
    return const Center(child: Text("Aucune donnée disponible."));
  }

  @override
  Widget build(BuildContext context) {
    calcul();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Exercice seance"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Expanded(child: buildExoList())],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addExerciceSeance',
              arguments: seanceId);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
