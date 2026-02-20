import 'package:stock_app/features/news/domain/entities/news.dart';

class NewsModel extends News {
  const NewsModel({
    required super.title,
    required super.summary,
    required super.url,
    required super.bannerImage,
    required super.sentimentLabel,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      url: json['url'] ?? '',
      bannerImage: json['banner_image'] ?? '',
      sentimentLabel: json['overall_sentiment_label'] ?? 'Neutral',
    );
  }

  // TODO: IMPLEMENT TOJSON UNTUK LOCAL
}
