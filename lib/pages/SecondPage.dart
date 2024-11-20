// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'DetailPage.dart';

class SecondPage extends StatefulWidget {
  final String menu;

  const SecondPage({super.key, required this.menu});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late Future<List<News>> futureNews;

  @override
  void initState() {
    super.initState();
    if (widget.menu == 'news') {
      futureNews = ApiService.fetchNews();
    }
    // Tambahkan logika untuk "blogs" dan "reports" jika ada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of ${widget.menu.capitalize()}'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<News>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          }

          final newsList = snapshot.data!;
          return ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final news = newsList[index];
              return ListTile(
                title: Text(news.title),
                subtitle: Text(news.summary),
                onTap: () {
                  // Navigasi ke halaman detail
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetailPage(id: news.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// Fungsi helper untuk kapitalisasi string
extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
