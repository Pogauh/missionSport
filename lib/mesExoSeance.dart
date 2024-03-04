import 'package:flutter/material.dart';

class MesExoSeancePage extends StatefulWidget {
  const MesExoSeancePage({Key? key, required this.seance}) : super(key: key);
  final dynamic seance;

  @override
  _MesExoSeancePageState createState() => _MesExoSeancePageState();
}

class _MesExoSeancePageState extends State<MesExoSeancePage> {
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
                  Text(
                    'Exercice: ${detailSeance['exercice']['nom']}',
                    style: const TextStyle(fontSize: 20),
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
    );
  }
}
