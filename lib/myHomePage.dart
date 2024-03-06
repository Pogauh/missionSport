import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String mdp = "";
  String txtButton = "Submit";
  bool _isLoading = false;

  Map<String, dynamic> dataMap = new Map();
  bool recupDataBool = false;

  Future<http.Response> recupConnect(String login, String mdp) {
    return http.post(
      Uri.parse(
          'https://s3-4680.nuage-peda.fr/missionSport/api/authentication_token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          convert.jsonEncode(<String, String>{'email': login, 'password': mdp}),
    );
  }

  Future<void> recupDataJson() async {
    var reponse = await recupConnect(email, mdp);
    if (reponse.statusCode == 200) {
      dataMap = convert.jsonDecode(reponse.body);
      recupDataBool = true;
    } else {
      print("erreur " + reponse.statusCode.toString());
    }
  }

  // methode qui permet la connection si les champs du formulaire sont valides
  startLoading() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      await recupDataJson();
      // si les données ont été récupéré
      if (recupDataBool) {
        // on navige vers accueil en détruisant le context actuel
        Navigator.popAndPushNamed(context, '/accueil', arguments: dataMap);
      } else {
        // sinon on affiche l'erreur et remet le booléen _isLoading à faux
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erreur dans la connection à la BDD"),
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // affiche une erreur concernant la saisie des informations
      // et remet le booléen _isLoading à faux
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur dans le login/mdp"),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // login
              TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    hintText: "Saisir votre email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Erreur de saisie";
                  } else {
                    email = value;
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
              ),
              // password
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Mot de passe",
                    hintText: "Saisir votre mot de passe"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Erreur de saisie";
                  } else {
                    mdp = value;
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  // selon la valeur de _isLoading, le bouton s'adapte
                  onPressed: _isLoading ? null : startLoading,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(txtButton),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/inscription');
                      },
                      child: const Text("S'inscrire"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
