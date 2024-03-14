import 'package:flutter/material.dart';

class DetailExercicePage extends StatefulWidget {
  const DetailExercicePage({Key? key, required this.exercice})
      : super(key: key);
  final dynamic exercice;

  @override
  _DetailExercicePageState createState() => _DetailExercicePageState();
}

class _DetailExercicePageState extends State<DetailExercicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            "Exercice",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(height: 30),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Text(
                        "Muscle travaillé :",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.exercice["muscle"]["nom"],
                        style: const TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.exercice["description"],
                        style: const TextStyle(fontSize: 15),
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
