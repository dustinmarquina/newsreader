import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../models/article.dart';
import '../constants.dart';

class NewsService {
  static const Duration _timeout = Duration(seconds: 10);

  static void _ensureApiKeySet() {
    const key = Constants.newsApiKey;
    if (key.isEmpty || key.contains('YOUR_API_KEY')) {
      throw Exception(
          'NewsAPI key is not set. Please put your key into lib/constants.dart');
    }
  }

  /// Fetch top headlines for a country (default 'us').
  /// Throws an exception with a descriptive message on network or API errors.
  static Future<List<Article>> fetchTopHeadlines(
      {String country = 'us'}) async {
    _ensureApiKeySet();

    final uri = Uri.parse('${Constants.baseUrl}/top-headlines')
        .replace(queryParameters: {
      'country': country,
      'apiKey': Constants.newsApiKey,
    });

    try {
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode != 200) {
        // Try to decode body for a more helpful message
        String detail = '';
        try {
          final body = json.decode(response.body);
          if (body is Map && body['message'] != null) {
            detail = ' - ${body['message']}';
          }
        } catch (_) {}
        throw Exception(
            'Failed to load news (status ${response.statusCode})$detail');
      }

      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] != 'ok') {
        throw Exception('NewsAPI error: ${data['message'] ?? 'Unknown error'}');
      }

      final List<dynamic> articlesJson = data['articles'] ?? [];
      return articlesJson.map((a) => Article.fromJson(a)).toList();
    } on SocketException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception('HTTP client error: ${e.message}');
    } on TimeoutException catch (_) {
      throw Exception(
          'Request timed out. Check your connection and try again.');
    }
  }

  /// Search everything endpoint (simple wrapper). Query must be non-empty.
  static Future<List<Article>> search(String query) async {
    if (query.trim().isEmpty) return [];
    _ensureApiKeySet();

    final uri =
        Uri.parse('${Constants.baseUrl}/everything').replace(queryParameters: {
      'q': query,
      'sortBy': 'publishedAt',
      'apiKey': Constants.newsApiKey,
      // consider adding 'pageSize': '50' if needed
    });

    try {
      final response = await http.get(uri).timeout(_timeout);
      if (response.statusCode != 200) {
        String detail = '';
        try {
          final body = json.decode(response.body);
          if (body is Map && body['message'] != null) {
            detail = ' - ${body['message']}';
          }
        } catch (_) {}
        throw Exception(
            'Failed to search news (status ${response.statusCode})$detail');
      }

      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] != 'ok') {
        throw Exception('NewsAPI error: ${data['message'] ?? 'Unknown error'}');
      }

      final List<dynamic> articlesJson = data['articles'] ?? [];
      return articlesJson.map((a) => Article.fromJson(a)).toList();
    } on SocketException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception('HTTP client error: ${e.message}');
    } on TimeoutException catch (_) {
      throw Exception(
          'Request timed out. Check your connection and try again.');
    }
  }
}
