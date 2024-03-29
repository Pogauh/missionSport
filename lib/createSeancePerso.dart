import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CreateseancePersoPage extends StatefulWidget {
  const CreateseancePersoPage({Key? key, required this.title})
      : super(key: key);

  final String title;

  @override
  State<CreateseancePersoPage> createState() => _CreateseancePersoPageState();
}

class _CreateseancePersoPageState extends State<CreateseancePersoPage> {
  String id = "";
  String type = "";
  String txtButton = "Submit";
  bool _isLoading = false;
  Map<String, dynamic> dataMap = {};
  bool recupDataBool = false;
  String date = "";

  Future<http.Response> fetchSeance(
      String id, String type, String formattedDate) {
    return http.post(
      Uri.parse('https://s3-4680.nuage-peda.fr/missionSport/api/seances'),
      headers: <String, String>{'Content-Type': 'application/ld+json'},
      body: convert
          .jsonEncode(<String, String>{'user': id, 'type': type, 'date': date}),
    );
  }

  Future<void> calcul() async {
    id = "/missionSport/api/users/${dataMap['data']['id']}";
    DateTime now = DateTime.now();
    date = now.toUtc().toIso8601String();
  }

  Future<void> recupDataJson() async {
    var reponse = await fetchSeance(id, type, date);
    if (reponse.statusCode == 201) {
      recupDataBool = true;
    } else if (reponse.statusCode == 500) {
      print("erreur " + reponse.body.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Un probleme est survenue"),
        ),
      );
    } else {
      print("erreur " + reponse.statusCode.toString());
    }
  }

  startLoading(String seanceType) async {
    setState(() {
      _isLoading = true;
      type = '/missionSport/api/types/$seanceType';
    });
    await calcul();
    await recupDataJson();
    if (recupDataBool) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("La séance a été crée"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur dans la connection à la BDD"),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    dataMap =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset('assets/images/nav_MissionSport.png'),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _isLoading ? null : () => startLoading("2"),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Séance haut du corps",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : () => startLoading("1"),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Séance bas du corps",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : () => startLoading("3"),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Séance Fullbody",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
