import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mission_sport/mesExoSeance.dart';
import 'package:mission_sport/modifSeance.dart';
import 'package:http/http.dart' as http;

class MesSeancePage extends StatefulWidget {
  const MesSeancePage({super.key, required String title});

  @override
  State<MesSeancePage> createState() => _MesSeancePageState();
}

class _MesSeancePageState extends State<MesSeancePage> {
  Map<String, dynamic> dataMap = {};
  Map<String, dynamic> seanceMap = {};
  int seanceId = 0;

  void _navigateToInfoPage(dynamic seance) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MesExoSeancePage(seance: seance)),
    );
  }

  editSeance(dynamic seance) {
    print("navigator push");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ModifSeancePage(seance: seance)),
    );
  }

  suppSeance(seance) {
    seanceId = seance['id'];
    deleteSeance(seanceId);
  }

  Future<void> deleteSeance(int seanceId) async {
    final response = await http.delete(
      Uri.parse(
          'https://s3-4680.nuage-peda.fr/missionSport/api/seances/$seanceId'),
      headers: <String, String>{
        'Content-Type': 'application/merge-patch+json',
      },
    );

    if (response.statusCode == 204) {
      print("La suppression a correctement été effectuée");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("La suppression de la séance a correctement été effectuée"),
        ),
      );
    } else {
      print('Reponse.body.toString = ' + response.body.toString());
    }
  }

  Widget buildSeanceList() {
    if (seanceMap.containsKey("seances")) {
      List<dynamic>? seances = seanceMap["seances"];

      if (seances != null && seances.isNotEmpty) {
        return ListView.builder(
          itemCount: seances.length,
          itemBuilder: (context, index) {
            final seance = seances[index];
            print(seance['id']);
            DateTime date = DateTime.parse(seance['date']);
            String formattedDate = "${date.day}/${date.month}/${date.year}";
            return InkWell(
              onTap: () => _navigateToInfoPage(seance),
              child: Card(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Commentaire: ${seance['commentaire'] ?? "Aucune données inscrite"}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Durée (min): ${seance['duree'] ?? "Aucune données inscrite"} ',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Type: ${seance['type']['nom']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => editSeance(seance),
                                style: ElevatedButton.styleFrom(
                                  textStyle: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                child: const Text("Modifier la séance"),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () => suppSeance(seance),
                                style: ElevatedButton.styleFrom(
                                  textStyle: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                child: const Text("Supprimer la séance"),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Text(
                        'Date: $formattedDate',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    }

    return Center(child: Text("Aucune donnée disponible."));
  }

  @override
  Widget build(BuildContext context) {
    seanceMap =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes séances"),
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
