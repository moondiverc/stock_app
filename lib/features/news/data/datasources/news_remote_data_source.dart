import 'dart:convert';

import 'package:stock_app/core/error/exceptions.dart';
import 'package:stock_app/core/secret/app_secrets.dart';
import 'package:stock_app/features/news/data/models/news_model.dart';
import 'package:http/http.dart' as http;

abstract interface class NewsRemoteDataSource {
  Future<List<NewsModel>> getNews();
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final http.Client client;

  NewsRemoteDataSourceImpl(this.client);

  @override
  Future<List<NewsModel>> getNews() async {
    try {
      final response = await client.get(
        Uri.parse(
          'https://www.alphavantage.co/query?function=NEWS_SENTIMENT&tickers=COIN,CRYPTO:BTC,FOREX:USD&time_from=20220410T0130&limit=1000&apikey=${AppSecrets.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('Note') || data.containsKey('Information')) {
          throw ServerException(data['Note'] ?? data['Information']);
        }

        final List<dynamic> feed = data['feed'] ?? [];

        return feed
            .map((json) => NewsModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          'Failed to connect to server: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
