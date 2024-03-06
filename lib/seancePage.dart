import 'package:flutter/material.dart';
import 'api/api_exercice.dart';

class SeancePage extends StatefulWidget {
  const SeancePage({super.key, required String title});

  @override
  State<SeancePage> createState() => _SeancePageState();
}

class _SeancePageState extends State<SeancePage> {
  List<dynamic>? _seancesData;

  @override
  void initState() {
    super.initState();
    fetchSeances();
  }

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

  Widget buildSeanceList() {
    if (_seancesData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _seancesData!.length,
      itemBuilder: (context, index) {
        final seance = _seancesData![index];
        return Card(
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
