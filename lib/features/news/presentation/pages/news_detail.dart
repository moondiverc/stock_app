import 'package:flutter/material.dart';
import 'package:stock_app/core/common/widgets/appbar.dart';
import 'package:stock_app/core/common/widgets/bottom_navbar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/news.dart';

class NewsDetailPage extends StatelessWidget {
  static route(News news) =>
      MaterialPageRoute(builder: (context) => NewsDetailPage(news: news));
  final News news;

  const NewsDetailPage({super.key, required this.news});

  // Fungsi untuk membuka link di browser bawaan HP
  Future<void> _launchArticleUrl(BuildContext context, String urlString) async {
    // Validasi URL tidak kosong
    if (urlString.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('URL artikel tidak tersedia')),
        );
      }
      return;
    }

    try {
      // Tambahkan https:// jika belum ada
      String url = urlString;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://$url';
      }

      final Uri uri = Uri.parse(url);

      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka link artikel')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  // Fungsi warna sentimen (Bisa disamakan dengan NewsCard)
  Color _getSentimentColor(String label) {
    final lowerLabel = label.toLowerCase();
    if (lowerLabel.contains('bullish')) return Colors.green.shade100;
    if (lowerLabel.contains('bearish')) return Colors.red.shade100;
    return const Color(0xFFF2F2F7);
  }

  Color _getSentimentTextColor(String label) {
    final lowerLabel = label.toLowerCase();
    if (lowerLabel.contains('bullish')) return Colors.green.shade800;
    if (lowerLabel.contains('bearish')) return Colors.red.shade800;
    return const Color(0xFF3A3A3C);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: StockAppBar(title: 'News', subtitle: 'News Details'),
      // Konten Utama yang bisa di-scroll
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Gambar Header Besar
            if (news.bannerImage.isNotEmpty)
              Image.network(
                news.bannerImage,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),

            // 2. Konten Teks (Padding)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label Sentimen & Sumber
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
                        'Alpha Vantage',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Judul Artikel
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight:
                          FontWeight.w900, // Extra tebal untuk judul utama
                      height: 1.3,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // Garis Pemisah (Divider)
                  Divider(color: Colors.grey.shade300, thickness: 1.0),
                  const SizedBox(height: 24.0),

                  // Ringkasan Artikel (Summary)
                  Text(
                    news.summary,
                    style: const TextStyle(
                      fontSize: 16.0,
                      height: 1.6, // Spasi baris diperlebar agar nyaman dibaca
                      color: Color(0xFF4A4A4A),
                    ),
                  ),
                  const SizedBox(height: 40.0), // Jarak lega ke bawah
                  // Button untuk buka artikel di browser
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchArticleUrl(context, news.url),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Baca Artikel Lengkap'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(85, 51, 187, 1.0),
                        foregroundColor: Colors.white,
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

      // 3. Tombol Call to Action yang selalu menempel di bawah (Sticky)
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
