import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtil {
  static Future<void> launchWebsite(
    BuildContext context,
    String urlString, {
    String unavailableMessage = 'URL is not available',
    String errorMessage = 'Could not open the website',
    bool addHttpsPrefix = false,
  }) async {
    if (urlString.isEmpty || urlString == '-') {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(unavailableMessage)));
      }
      return;
    }

    try {
      String url = urlString;

      if (addHttpsPrefix &&
          !url.startsWith('http://') &&
          !url.startsWith('https://')) {
        url = 'https://$url';
      }

      final Uri uri = Uri.parse(url);

      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
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
}
