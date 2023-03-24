import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> fetchEpisodes(int id) async {
  final url = Uri.https('rickandmortyapi.com', '/api/character/$id');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final episodes = List<String>.from(data['episode']);
    return episodes;
  } else {
    throw Exception('Failed to fetch episodes');
  }
}
class EpisodesScreen extends StatelessWidget {
  final int id;

  EpisodesScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Episodes'),
      ),
      body: FutureBuilder(
        future: EpisodesService.fetchEpisodes(id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Episode> episodes = snapshot.data as List<Episode>;
            return ListView.builder(
              itemCount: episodes.length,
              itemBuilder: (context, index) {
                Episode episode = episodes[index];
                return ListTile(
                  title: Text(episode.name),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
