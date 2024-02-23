import 'package:flutter/material.dart';
import 'package:mission_sport/fetch.dart';
import 'api/api_exercice.dart';

class SeancePage extends StatefulWidget {
  const SeancePage({super.key, required String title});

  @override
  State<SeancePage> createState() => _SeancePageState();
}

class _SeancePageState extends State<SeancePage> {
  List<dynamic>? _seancesData;

  @override
  // initie la récupération des exercice
  void initState() {
    super.initState();
    fetchSeances();
  }

  // Récupération des users
  fetchSeances() async {
    try {
      final seancesData = await GetSeance.fetchSeance();
      setState(() {
        _seancesData = seancesData['hydra:member'];
      });
    } catch (e) {
      print('Error fetching seances data: $e');
    }
  }

  // Liste des clients
  Widget buildSeanceList() {
    if (_seancesData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _seancesData!.length,
      itemBuilder: (context, index) {
        final seance = _seancesData![index];
        //Inkwell pour marqué chaque utilisateur pour aller à la page fidélité
        return Card(
          // Section pour le client
          child: Card(
            margin: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Date: ${seance['date']}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Durée: ${seance['duree']}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Commentaire: ${seance['commentaire']}',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Barre de recherche
  @override
  Widget build(BuildContext context) {
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
            child: buildSeanceList(),
          ),
        ],
      ),
    );
  }
}
