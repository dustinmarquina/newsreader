class Article {
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;
  final String sourceName;

  Article({
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    required this.sourceName,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No title',
      description: json['description'],
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'])
          : null,
      content: json['content'],
      sourceName: json['source'] != null && json['source']['name'] != null
          ? json['source']['name']
          : 'Unknown',
    );
  }
}
