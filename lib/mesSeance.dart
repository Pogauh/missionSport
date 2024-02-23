import 'package:flutter/material.dart';
import 'api/api_exercice.dart';

class MesSeancePage extends StatefulWidget {
  const MesSeancePage({super.key, required String title});

  @override
  State<MesSeancePage> createState() => _MesSeancePageState();
}

class _MesSeancePageState extends State<MesSeancePage> {
  List<dynamic>? _userData;
  Map<String, dynamic> dataMap = new Map();

  @override
  // initie la récupération des seances
  void initState() {
    super.initState();
    fetchUser();
  }

  Widget buildSeanceList() {
    if (_userData == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: _userData!.length,
      itemBuilder: (context, index) {
        final user = _userData![index];
        //Inkwell a la place de Card [plus tard]pour marqué chaque seance pour aller à la page DetailSeance
        return Card(
          //Mettre inkWell et le on tap
          //onTap: () => _navigateToEditPage(user),
          child: Card(
            margin: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Commentaire: ${user['commentaire']}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Durée: ${user['duree']}',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Récupération des seances
  fetchUser() async {
    try {
      String id = dataMap['data']['id'].toString();
      final userData = await GetUser.fetchUser(id);
      setState(() {
        _userData = userData['Seance'];
      });
    } catch (e) {
      print('Error fetching seances data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    dataMap =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [buildSeanceList()],
      ),
    );
  }
}
