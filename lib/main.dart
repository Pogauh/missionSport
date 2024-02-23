import 'package:flutter/material.dart';
import 'package:mission_sport/pageExercice.dart';
import 'package:mission_sport/seancePage.dart';
import 'package:mission_sport/mesSeance.dart';

import 'myHomePage.dart';

import 'accueilpage.dart';
import 'inscriptionPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Mission sport',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Mission sport'),
        debugShowCheckedModeBanner: false,
        // définition des routes de l'application
        routes: <String, WidgetBuilder>{
          '/accueil': (BuildContext context) =>
              const AccueilPage(title: 'Accueil'),
          '/login': (BuildContext context) => const MyHomePage(title: 'Login'),
          '/inscription': (BuildContext context) =>
              const InscriptionPage(title: 'Inscription'),
          '/exercice': (BuildContext) => const ExercicePage(title: 'Exercice'),
          '/seance': (BuildContext) => const SeancePage(title: 'Seance'),
          '/mesSeance': (BuildContext) =>
              const MesSeancePage(title: 'MesSeance')
        });
  }
}
