import 'package:flutter/material.dart';
import 'package:stock_app/features/news/domain/entities/news.dart';

class NewsCard extends StatelessWidget {
  final News news;
  final VoidCallback onTap;

  const NewsCard({super.key, required this.news, required this.onTap});

  Color _getSentimentColor(String label) {
    final lowerLabel = label.toLowerCase();
    if (lowerLabel.contains('bullish')) {
      return Colors.green.shade100;
    } else if (lowerLabel.contains('bearish')) {
      return Colors.red.shade100;
    }
    return const Color(0xFFF2F2F7);
  }

  Color _getSentimentTextColor(String label) {
    final lowerLabel = label.toLowerCase();
    if (lowerLabel.contains('bullish')) {
      return Colors.green.shade800;
    } else if (lowerLabel.contains('bearish')) {
      return Colors.red.shade800;
    }
    return const Color(0xFF3A3A3C);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: const Color(0xFFE5E5EA), width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.bannerImage.isNotEmpty)
              Image.network(
                news.bannerImage,
                height: 160.0,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: _getSentimentColor(news.sentimentLabel),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(
                          news.sentimentLabel.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: _getSentimentTextColor(news.sentimentLabel),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        news.authors.isNotEmpty
                            ? '•  ${news.authors[0]}'
                            : '•  Alpha Vantage',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),

                  Text(
                    news.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: Colors.black87,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  Text(
                    news.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF666666),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
