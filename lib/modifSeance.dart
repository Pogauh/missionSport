import 'dart:convert' as convert;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class ModifSeancePage extends StatefulWidget {
  final dynamic seance;

  ModifSeancePage({required this.seance});

  @override
  _ModifSeancePageState createState() => _ModifSeancePageState();
}

class _ModifSeancePageState extends State<ModifSeancePage> {
  final TextEditingController _commentaireController = TextEditingController();
  final TextEditingController _dureeController = TextEditingController();
  String seanceId = "";
  String commentaire = "";
  int duree = 0;

  @override
  void initState() {
    super.initState();

    _commentaireController.text = widget.seance['commentaire'] ?? '';
    _dureeController.text = widget.seance['duree']?.toString() ?? '0';
  }

  calcul() async {
    seanceId = widget.seance["seanceId"].toString();
    seanceId = '"/missionSport/api/seances/${seanceId}"';
    commentaire = _commentaireController.text;
    duree = int.parse(_dureeController.text);
  }

  static Future<void> editSeance(
      int seanceId, String commentaire, int duree) async {
    final response = await http.patch(
      Uri.parse(
          'https://s3-4680.nuage-peda.fr/missionSport/api/seances/$seanceId'),
      headers: <String, String>{
        'Content-Type': 'application/merge-patch+json',
      },
      body: convert.jsonEncode({'commentaire': commentaire, 'duree': duree}),
    );

    if (response.statusCode == 200) {
      print("La requete à correctement été envoyé");
      print('Reponse.body.toString = ' + response.body.toString());

      return json.decode(response.body);
    } else {
      print('Reponse.body.toString = ' + response.body.toString());
    }
  }

  void _updateSeance() async {
    await calcul();
    print("le commentaire : " + commentaire);
    print("La duree : " + duree.toString());
    try {
      await editSeance(widget.seance['id'], commentaire, duree);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seance mis à jour avec succès'),
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
        title: const Text('Modifier la séance'),
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
              controller: _dureeController,
              decoration: const InputDecoration(labelText: 'Duree'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateSeance,
              child: const Text('Enregistrer les modifications'),
            ),
          ],
        ),
      ),
    );
  }
}
