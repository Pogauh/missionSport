import 'package:flutter/material.dart';

class NewSeancePage extends StatefulWidget {
  const NewSeancePage({super.key, required String title});

  @override
  State<NewSeancePage> createState() => _NewSeancePageState();
}

class _NewSeancePageState extends State<NewSeancePage> {
  List<dynamic> deuxExercices = [];
  bool _isLoading = false;

  envoiExo() {}

  Widget buildPropositionList() {
    return ListView.builder(
      itemCount: deuxExercices.length,
      itemBuilder: (context, index) {
        // Récupérez la séance à l'index donné
        final exercice = deuxExercices[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  'Nom: ${exercice['nom']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description: ${exercice['description']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    deuxExercices = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
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
            child: buildPropositionList(),
          ),
          Row(
            children: [
              ElevatedButton(
                // selon la valeur de _isLoading, le bouton s'adapte
                onPressed: _isLoading ? null : envoiExo,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Accepter"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
