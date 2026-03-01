import 'package:flutter/material.dart';
import 'package:stock_app/core/common/widgets/stock_appbar.dart';
import 'package:stock_app/core/common/widgets/bottom_navbar.dart';
import 'package:stock_app/core/theme/app_pallete.dart';
import 'package:stock_app/core/utils/url_launcher.dart';
import 'package:stock_app/features/news/domain/entities/news.dart';

class NewsDetailPage extends StatelessWidget {
  static route(News news) =>
      MaterialPageRoute(builder: (context) => NewsDetailPage(news: news));
  final News news;

  const NewsDetailPage({super.key, required this.news});

  Color _getSentimentColor(String label) {
    final lowerLabel = label.toLowerCase();

    if (lowerLabel.contains('bullish')) {
      return AppPallete.sentimentBullish;
    }
    if (lowerLabel.contains('bearish')) {
      return AppPallete.sentimentBearish;
    }

    return AppPallete.sentimentNeutral;
  }

  Color _getSentimentTextColor(String label) {
    final lowerLabel = label.toLowerCase();

    if (lowerLabel.contains('bullish')) {
      return AppPallete.sentimentBullishText;
    }
    if (lowerLabel.contains('bearish')) {
      return AppPallete.sentimentBearishText;
    }

    return AppPallete.sentimentNeutralText;
  }

  @override
  Widget build(BuildContext context) {
    final String appBarTitle = news.title.trim().isNotEmpty
        ? news.title
        : 'News Details';
    final String appBarSubtitle =
        news.authors.isNotEmpty && news.authors.first.trim().isNotEmpty
        ? news.authors.first
        : 'Anonymous';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: StockAppBar(title: appBarTitle, subtitle: appBarSubtitle),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.bannerImage.isNotEmpty)
              Image.network(
                news.bannerImage,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),

            // sentiment label and authors
            Padding(
              padding: const EdgeInsets.all(24.0),
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
                            fontSize: 12.0,
                            fontWeight: FontWeight.w800,
                            color: _getSentimentTextColor(news.sentimentLabel),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12.0),

                      Text(
                        news.authors.isNotEmpty ? news.authors[0] : 'Anonymous',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0),

                  // news title
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w900,
                      height: 1.3,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // authors list
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppPallete.themeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: AppPallete.themeColor.withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Authors:',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: AppPallete.textColor,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 6.0,
                          children:
                              (news.authors.isNotEmpty
                                      ? news.authors
                                      : ['Anonymous'])
                                  .map((author) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                        vertical: 5.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppPallete.whiteColor,
                                        borderRadius: BorderRadius.circular(
                                          6.0,
                                        ),
                                        border: Border.all(
                                          color: AppPallete.themeColor,
                                          width: 0.8,
                                        ),
                                      ),
                                      child: Text(
                                        author,
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: AppPallete.themeColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  })
                                  .toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24.0),

                  Divider(color: Colors.grey.shade300, thickness: 1.0),

                  const SizedBox(height: 24.0),

                  // news summary
                  Text(
                    news.summary,
                    style: const TextStyle(
                      fontSize: 16.0,
                      height: 1.6,
                      color: AppPallete.textColor,
                    ),
                  ),

                  const SizedBox(height: 40.0),

                  // button url launcher
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => UrlLauncherUtil.launchWebsite(
                        context,
                        news.url,
                        unavailableMessage: 'URL artikel tidak tersedia',
                        errorMessage: 'Tidak dapat membuka link artikel',
                        addHttpsPrefix: true,
                      ),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Baca Artikel Lengkap'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.themeColor,
                        foregroundColor: AppPallete.whiteColor,
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavbar(currentIndex: 1),
    );
  }
}
