import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mission_sport/ModifExercice.dart';
import 'package:http/http.dart' as http;

class DetailExercicePage extends StatefulWidget {
  const DetailExercicePage({Key? key, required this.exercice})
      : super(key: key);
  final dynamic exercice;

  @override
  _DetailExercicePageState createState() => _DetailExercicePageState();
}

class _DetailExercicePageState extends State<DetailExercicePage> {
  String exerciceId = "";

  calcul() {
    exerciceId = widget.exercice["id"].toString();
  }

  @override
  Widget build(BuildContext context) {
    calcul();
    print(widget.exercice["muscle"]["nom"]);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            "Exercice",
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Image.asset('assets/images/nav_MissionSport.png'),
              Image.asset('assets/images/${widget.exercice['image']}',
                  height: 200, width: 200),
              Text(
                widget.exercice["nom"],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(height: 30),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        "Muscle travaillé :",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.exercice["muscle"]["nom"],
                        style: TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.exercice["description"],
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
