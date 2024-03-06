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

  void _navigateToInfoPage(dynamic seance) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MesExoSeancePage(seance: seance)),
    );
  }

  Widget buildSeanceList() {
    if (seanceMap.containsKey("seances")) {
      List<dynamic>? seances = seanceMap["seances"];

      if (seances != null && seances.isNotEmpty) {
        return ListView.builder(
          itemCount: seances.length,
          itemBuilder: (context, index) {
            final seance = seances[index];
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
                        'Commentaire: ${seance['commentaire']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Durée: ${seance['duree']} minutes',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Type: ${seance['type']['nom']}',
                            style: const TextStyle(fontSize: 16),
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
