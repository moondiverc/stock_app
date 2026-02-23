class News {
  final String title;
  final String summary;
  final String url;
  final String bannerImage;
  final String sentimentLabel;
  final List<String> authors;

  const News({
    required this.title,
    required this.summary,
    required this.url,
    required this.bannerImage,
    required this.sentimentLabel,
    required this.authors,
  });
}
