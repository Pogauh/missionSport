import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class GetExercice {
  static Future<Map<String, dynamic>> fetchExercice() async {
    final response = await http.get(
        Uri.parse('https://s3-4680.nuage-peda.fr/missionSport/api/exercices'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }
}

class GetSeance {
  static Future<Map<String, dynamic>> fetchSeance() async {
    final response = await http.get(
        Uri.parse('https://s3-4680.nuage-peda.fr/missionSport/api/seances'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }
}

class GetUser {
  static Future<Map<String, dynamic>> fetchUser(id) async {
    print("l'id de l'user : " + id);
    final response = await http.get(
        Uri.parse('https://s3-4680.nuage-peda.fr/missionSport/api/users/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }
}

class PatchExercice {
  static Future<void> updateExercice(
      int detailSeanceId, Map<String, dynamic> exerciceData) async {
    final response = await http.patch(
      Uri.parse(
          'https://s3-4680.nuage-peda.fr/missionSport/api/detail_seances/$detailSeanceId'),
      headers: <String, String>{
        'Content-Type': 'application/merge-patch+json',
      },
      body: jsonEncode(exerciceData),
    );

    if (response.statusCode == 200) {
      print("Cest PASSERR");
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }
}
