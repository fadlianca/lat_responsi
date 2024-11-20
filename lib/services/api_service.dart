import 'dart:convert';
import 'package:http/http.dart' as http;

// Model untuk menyimpan data News
class News {
  final int id;
  final String title;
  final String summary;

  News({required this.id, required this.title, required this.summary});

  // Fungsi untuk mapping dari JSON ke News
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      summary: json['summary'],
    );
  }

  get url => null;
}

// Service untuk mengambil data dari API
class ApiService {
  static const String baseUrl = 'https://api.spaceflightnewsapi.net/v4';

  // Fungsi untuk mengambil list News
  static Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse('$baseUrl/articles/'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => News.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  // Fungsi untuk mengambil detail News berdasarkan ID
  static Future<News> fetchNewsDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/articles/$id/'));

    if (response.statusCode == 200) {
      return News.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load news detail');
    }
  }
}
