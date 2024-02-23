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
    print('lid ' + id);
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
