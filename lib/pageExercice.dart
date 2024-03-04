import 'package:flutter/material.dart';
import 'api/api_exercice.dart';

class ExercicePage extends StatefulWidget {
  const ExercicePage({super.key, required String title});

  @override
  State<ExercicePage> createState() => _ExercicePageState();
}

class _ExercicePageState extends State<ExercicePage> {
  Map<String, dynamic>? _exercicesData;
  List<dynamic>? _filteredExercices;

  TextEditingController _nomController = TextEditingController();

  @override
  // initie la récupération des exercice
  void initState() {
    super.initState();
    fetchExercice();
  }

  // Récupération des users
  fetchExercice() async {
    try {
      final exercicesData = await GetExercice.fetchExercice();
      print(exercicesData);
      setState(() {
        _exercicesData = exercicesData;
        _filteredExercices = _exercicesData!['hydra:member'];
      });
    } catch (e) {
      print('Error fetching users data: $e');
    }
  }

  // fonction pour rechercher les users
  void _searchExercices() {
    if (_exercicesData != null) {
      // Variables qui prend en compte les ecritures du champ de recherche
      final String nomQuery = _nomController.text.toLowerCase();

      setState(() {
        _filteredExercices = _exercicesData!['hydra:member'].where((exercice) {
          final String nom = exercice['nom']?.toString().toLowerCase() ?? '';

          // Conditions que les variables doivent respecter pour être inclure
          // le client dans la liste envoyé à FilteredUsers
          return nom.contains(nomQuery);
        }).toList();
      });
    }
  }

  // Liste des clients
  Widget buildExerciceList() {
    if (_filteredExercices == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _filteredExercices!.length,
      itemBuilder: (context, index) {
        final exercice = _filteredExercices![index];
        //Inkwell pour marqué chaque utilisateur pour aller à la page fidélité
        return Card(
          // Section pour le client
          child: Card(
            margin: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Nom: ${exercice['nom']}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Description: ${exercice['description']}',
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
        title: Row(
          children: [
            Expanded(
              child: TextField(
                // Permet la mise a jour en temps réel
                controller: _nomController,
                onChanged: (_) => _searchExercices(),
                decoration: const InputDecoration(
                  hintText: 'Nom',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
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
            child: buildExerciceList(),
          ),
        ],
      ),
    );
  }
}
