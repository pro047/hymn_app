class ScoreItem {
  final String id;
  final String title;
  final String subtitle;
  final String mood;
  final DateTime? date;
  final String? fileUri;
  final String? fileUrl;
  final String? downloadUrl;

  const ScoreItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.mood,
    this.date,
    this.fileUri,
    this.fileUrl,
    this.downloadUrl,
  });

  factory ScoreItem.fromJson(Map<String, dynamic> json) {
    final dateValue = json['week_of'] ?? json['date'] ?? json['day'];
    DateTime? parsedDate;
    if (dateValue is String) {
      parsedDate = DateTime.tryParse(dateValue);
    }
    String stringValue(dynamic value) {
      if (value == null) {
        return '';
      }
      return value.toString();
    }

    String stringValueWithFallback(dynamic value, String fallback) {
      final result = stringValue(value);
      return result.isEmpty ? fallback : result;
    }

    return ScoreItem(
      id: stringValueWithFallback(json['id'] ?? json['score_id'], ''),
      title: stringValueWithFallback(json['title'] ?? json['name'], '제목 없음'),
      subtitle: stringValue(json['subtitle'] ?? json['number']),
      mood: stringValue(json['mood']),
      date: parsedDate,
      fileUri: json['file_uri'] as String?,
      fileUrl: json['file_url'] as String?,
      downloadUrl: json['download_url'] as String?,
    );
  }
}
