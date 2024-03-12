import 'package:flutter/material.dart';
import 'package:mission_sport/mesExoSeance.dart';
import 'package:mission_sport/modifSeance.dart';

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

  editSeance(dynamic seance) {
    print("navigator push");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ModifSeancePage(seance: seance)),
    );
  }

  void test() {
    print('Methode Test');
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
                          ElevatedButton(
                            // onPressed: () {
                            //   print("test");
                            // },
                            onPressed: () => editSeance(seance),
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            child: const Text("Modifier la séance"),
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
