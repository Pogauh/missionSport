import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ModifExercicePage extends StatefulWidget {
  final dynamic detailSeance;

  ModifExercicePage({required this.detailSeance});

  @override
  _ModifExercicePageState createState() => _ModifExercicePageState();
}

class _ModifExercicePageState extends State<ModifExercicePage> {
  final TextEditingController _commentaireController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _repetitionController = TextEditingController();
  String seanceId = "";
  String exerciceId = "";
  String commentaire = "";

  @override
  void initState() {
    super.initState();

    _commentaireController.text = widget.detailSeance['commentaire'] ?? '';
    _setsController.text = widget.detailSeance['sets']?.toString() ?? '0';
    _repetitionController.text =
        widget.detailSeance['repetition']?.toString() ?? '0';
  }

  calcul() async {
    exerciceId = widget.detailSeance["exercice"]["id"].toString();
    exerciceId = '"/missionSport/api/exercices/$exerciceId"';
    seanceId = widget.detailSeance["seanceId"].toString();
    seanceId = '"/missionSport/api/seances/${seanceId}"';
    commentaire = _commentaireController.text;
    print(seanceId + exerciceId);
  }

  static Future<void> editExercice(
      int detailSeanceId, Map<String, dynamic> updatedExerciceData) async {
    final response = await http.patch(
      Uri.parse(
          'https://s3-4680.nuage-peda.fr/missionSport/api/detail_seances/$detailSeanceId'),
      headers: <String, String>{
        'Content-Type': 'application/merge-patch+json',
      },
      body: jsonEncode(updatedExerciceData),
    );

    if (response.statusCode == 200) {
      print("La requete à correctement été envoyé");
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }

  void _updateExercice() async {
    await calcul();
    try {
      final Map<String, dynamic> updatedExerciceData = {
        '"commentaire"': '"$commentaire"',
        '"sets"': int.parse(_setsController.text),
        '"repetition"': int.parse(_repetitionController.text),
        '"seance"': seanceId,
        '"exercice"': exerciceId,
      };

      print(
          "UpdatedExerciceData dans Modif exercice        $updatedExerciceData");

      await editExercice(widget.detailSeance['id'], updatedExerciceData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exercice mis à jour avec succès'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error updating exercice: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier utilisateur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _commentaireController,
              decoration: const InputDecoration(labelText: 'Commentaire'),
            ),
            TextField(
              controller: _setsController,
              decoration: const InputDecoration(labelText: 'Sets'),
            ),
            TextField(
              controller: _repetitionController,
              decoration: const InputDecoration(labelText: 'Répétitions'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateExercice,
              child: const Text('Enregistrer les modifications'),
            ),
          ],
        ),
      ),
    );
  }
}
