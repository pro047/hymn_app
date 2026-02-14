import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/score_item.dart';

class ScoresApi {
  static final String _endpoint =
      dotenv.env['SCORES_API_URL'] ?? 'http://172.30.1.12:8000/scores';

  Future<List<ScoreItem>> fetchScores() async {
    final response = await http.get(Uri.parse('$_endpoint/scores'));
    if (response.statusCode != 200) {
      debugPrint('server=${response.headers['server']}');
      debugPrint('content-type=${response.headers['content-type']}');
      debugPrint('body(head)=${response.body.substring(0, 153)}');
      throw Exception(
        'Failed to load scores (${response.statusCode}) / $_endpoint',
      );
    }

    debugPrint('payload : ${response.body}');

    final payload = jsonDecode(response.body);

    if (payload is List) {
      return payload
          .whereType<Map<String, dynamic>>()
          .map(ScoreItem.fromJson)
          .toList();
    }

    if (payload is Map && payload['data'] is List) {
      final data = payload['data'] as List;
      return data
          .whereType<Map<String, dynamic>>()
          .map(ScoreItem.fromJson)
          .toList();
    }

    return [];
  }
}
