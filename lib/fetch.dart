import 'package:mission_sport/api/api_exercice.dart';

fetchExercice() async {
  try {
    final exerciceData = await GetExercice.fetchExercice();
  } catch (e) {
    print('Error fetching exercice data: $e');
  }
}

fetchSeances() async {
  try {
    final seanceData = await GetSeance.fetchSeance();
  } catch (e) {
    print('Error fetching exercice data: $e');
  }
}
