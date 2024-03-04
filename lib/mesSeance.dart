import 'package:flutter/material.dart';
import 'package:mission_sport/mesExoSeance.dart';

class MesSeancePage extends StatefulWidget {
  const MesSeancePage({super.key, required String title});

  @override
  State<MesSeancePage> createState() => _MesSeancePageState();
}

class _MesSeancePageState extends State<MesSeancePage> {
  Map<String, dynamic> dataMap = {};
  Map<String, dynamic> seanceMap = {};

  //fonction qui renvoi vers la page fidelité du client
  void _navigateToInfoPage(dynamic seance) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MesExoSeancePage(seance: seance)),
    );
  }

  Widget buildSeanceList() {
    // Vérifiez si la clé "seances" existe dans seanceMap
    if (seanceMap.containsKey("seances")) {
      // Récupérez la liste de séances
      List<dynamic>? seances = seanceMap["seances"];

      // Vérifiez si la liste de séances est non nulle et a au moins 1 élément
      if (seances != null && seances.isNotEmpty) {
        return ListView.builder(
          itemCount: seances.length,
          itemBuilder: (context, index) {
            // Récupérez la séance à l'index donné
            final seance = seances[index];

            return InkWell(
              onTap: () => _navigateToInfoPage(seance),
              child: Card(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Commentaire: ${seance['commentaire']}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Durée: ${seance['duree']}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    }

    // Si la clé "seances" n'existe pas ou la liste est vide, affichez un message indiquant l'absence de données.
    return Center(child: Text("Aucune donnée disponible."));
  }

  @override
  Widget build(BuildContext context) {
    seanceMap =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: buildSeanceList(),
          )
        ],
      ),
    );
  }
}
