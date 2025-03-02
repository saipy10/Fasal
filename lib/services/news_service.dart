import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsService {
  static const String _apiKey =
      'd8041a6fe3554578aba4d93a1e07fde6'; // Replace with your actual NewsAPI key
  static const String _baseUrl = 'https://newsapi.org/v2/everything';
  static const String _query =
      'agriculture+India'; // Refined query for Indian agriculture
  static const String _language = 'en'; // English language
  static const String _sortBy = 'publishedAt'; // Sort by most recent

  Future<List<Map<String, String>>> fetchNews() async {
    try {
      // Construct the URL with query parameters
      final uri = Uri.parse(
        '$_baseUrl?q=$_query&language=$_language&sortBy=$_sortBy&apiKey=$_apiKey',
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final articles = data['articles'] as List<dynamic>?;

        if (articles == null || articles.isEmpty) {
          return [
            {
              'title': 'No News Available',
              'description': 'No recent articles found for Indian agriculture.',
              'url': '',
            },
          ];
        }

        return articles.take(5).map((article) {
          return {
            'title': (article['title'] ?? 'No Title').toString(),
            'description':
                (article['description'] ?? 'No Description').toString(),
            'url': (article['url'] ?? '').toString(),
          };
        }).toList();
      } else {
        throw Exception(
          'Failed to load news: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      return [
        {
          'title': 'Error',
          'description': 'Failed to fetch news: $e',
          'url': '',
        },
      ];
    }
  }
}
