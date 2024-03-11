import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  int sets = 0;
  int repetition = 0;

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
    sets = int.parse(_setsController.text);
    repetition = int.parse(_repetitionController.text);

  }

  static Future<void> editExercice(
      int detailSeanceId,String commentaire, int sets, int repetition) async {
    final response = await http.patch(
      Uri.parse(
          'https://s3-4680.nuage-peda.fr/missionSport/api/detail_seances/$detailSeanceId'),
      headers: <String, String>{
        'Content-Type': 'application/merge-patch+json',
      },
      body: 
      convert.jsonEncode({'commentaire': commentaire ,'sets': sets, 'repetition':repetition}),
    );

    if (response.statusCode == 200) {
      print("La requete à correctement été envoyé");
      print('Reponse.body.toString = '+ response.body.toString());

      return json.decode(response.body);
    } else {
            print('Reponse.body.toString = '+ response.body.toString());

          
    }
  }

  void _updateExercice() async {
    await calcul();
    print("le commentaire : "+commentaire);
    print("nombre de sets : "+ sets.toString());
    print("nombre de repetition : "+repetition.toString());

    try {
      await editExercice(widget.detailSeance['id'],commentaire, sets, repetition);
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
