import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';

class NewsDetailPage extends StatelessWidget {
  final int id;

  const NewsDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Detail'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<News>(
        future: ApiService.fetchNewsDetail(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available.'));
          }

          final news = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(news.summary),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final url = news.url;
                    if (await _canLaunchUrl(url)) {
                      await _launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: const Text('Read More'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<bool> _canLaunchUrl(String url) async {
    final response = await http.head(Uri.parse(url));
    return response.statusCode == 200;
  }

  Future<void> _launchUrl(String url) async {
    await http.get(Uri.parse(url));
  }
}
