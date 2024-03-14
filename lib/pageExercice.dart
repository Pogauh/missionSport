import 'package:flutter/material.dart';
import 'package:mission_sport/detailExercice.dart';
import 'api/api_exercice.dart';

class ExercicePage extends StatefulWidget {
  const ExercicePage({super.key, required String title});

  @override
  State<ExercicePage> createState() => _ExercicePageState();
}

class _ExercicePageState extends State<ExercicePage> {
  Map<String, dynamic>? _exercicesData;
  List<dynamic>? _filteredExercices;

  final TextEditingController _nomController = TextEditingController();

  @override
  // initie la récupération des exercice
  void initState() {
    super.initState();
    fetchExercice();
  }

  // Récupération des exercices
  fetchExercice() async {
    try {
      final exercicesData = await GetExercice.fetchExercice();
      setState(() {
        _exercicesData = exercicesData;
        _filteredExercices = _exercicesData!['hydra:member'];
      });
    } catch (e) {
      print('Error fetching users data: $e');
    }
  }

  // fonction pour rechercher les exercices
  void _searchExercices() {
    if (_exercicesData != null) {
      // Variables qui prend en compte les ecritures du champ de recherche
      final String nomQuery = _nomController.text.toLowerCase();

      setState(() {
        _filteredExercices = _exercicesData!['hydra:member'].where((exercice) {
          final String nom = exercice['nom']?.toString().toLowerCase() ?? '';

          // Conditions que les variables doivent respecter pour être inclure
          // l'exercice dans la liste envoyé à FilteredExercices
          return nom.contains(nomQuery);
        }).toList();
      });
    }
  }

  Future<void> _navigateToExoDetailPage(dynamic exercice) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailExercicePage(exercice: exercice)),
    );
  }

  // Liste des exercices
  Widget buildExerciceList() {
    if (_filteredExercices == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _filteredExercices!.length,
      itemBuilder: (context, index) {
        final exercice = _filteredExercices![index];
        return InkWell(
          onTap: () => _navigateToExoDetailPage(exercice),
          child: Card(
            margin: EdgeInsets.all(5.0),
            child: Column(
              children: [
                Text(
                  'Nom: ${exercice['nom']}',
                  style: const TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                  ),
                ),
                Text(
                  'Description: ${exercice['description']}',
                  style: const TextStyle(fontSize: 20),
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
        title: const Row(children: [
          Text("Liste des exercices"),
        ]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFFFFFFF)),
                left: BorderSide(color: Color(0xFFFFFFFF)),
              ),
            ),
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
              child: TextField(
                controller: _nomController,
                onChanged: (_) => _searchExercices(),
                decoration: InputDecoration(
                  hintText: 'Rechercher un exercice',
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 249, 249, 249),
                ),
              ),
            ),
          ),
          Expanded(
            child: buildExerciceList(),
          ),
        ],
      ),
    );
  }
}
