import 'package:stock_app/features/news/domain/entities/news.dart';

class NewsModel extends News {
  const NewsModel({
    required super.title,
    required super.summary,
    required super.url,
    required super.bannerImage,
    required super.sentimentLabel,
    required super.authors,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    List<String> authors = [];
    if (json['authors'] != null && json['authors'] is List) {
      authors = List<String>.from(
        (json['authors'] as List).map((author) => author.toString()),
      );
    }

    return NewsModel(
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      url: json['url'] ?? '',
      bannerImage: json['banner_image'] ?? '',
      sentimentLabel: json['overall_sentiment_label'] ?? 'Neutral',
      authors: authors,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'summary': summary,
      'url': url,
      'banner_image': bannerImage,
      'overall_sentiment_label': sentimentLabel,
      'authors': authors,
    };
  }
}
