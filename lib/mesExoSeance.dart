import 'package:flutter/material.dart';
import 'package:mission_sport/addExerciceSeance.dart';
import 'package:mission_sport/seancePage.dart';

class MesExoSeancePage extends StatefulWidget {
  const MesExoSeancePage({Key? key, required this.seance}) : super(key: key);
  final dynamic seance;

  @override
  _MesExoSeancePageState createState() => _MesExoSeancePageState();
}

class _MesExoSeancePageState extends State<MesExoSeancePage> {
  String seanceId = "";

  calcul() {
    seanceId = widget.seance["id"].toString();
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
            return Card(
              margin: const EdgeInsets.all(8.0),
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
                            'Series: ${detailSeance['sets']}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Répétitions: ${detailSeance['repetition']}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Commentaire: ${detailSeance['commentaire']}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ))
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
    }

    // Si la clé "detailSeances" n'existe pas ou la liste est vide, affichez un message indiquant l'absence de données.
    return Center(child: Text("Aucune donnée disponible."));
  }

  @override
  Widget build(BuildContext context) {
    calcul();
    return Scaffold(
      appBar: AppBar(
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
