import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stock_app/core/error/exceptions.dart';
import 'package:stock_app/core/secret/app_secrets.dart';
import 'package:stock_app/features/stock/data/models/stock_model.dart';

abstract interface class StockRemoteDataSource {
  Future<List<StockModel>> getStocks();
}

class StockRemoteDataSourceImpl implements StockRemoteDataSource {
  final http.Client client;

  StockRemoteDataSourceImpl(this.client);

  @override
  Future<List<StockModel>> getStocks() async {
    try {
      final response = await client.get(
        Uri.parse(
          'https://www.alphavantage.co/query?function=TOP_GAINERS_LOSERS&apikey=${AppSecrets.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('Note') || data.containsKey('Information')) {
          throw ServerException(data['Note'] ?? data['Information']);
        }

        final List<dynamic> topGainers = data['top_gainers'] ?? [];

        return topGainers.map((json) => StockModel.fromJson(json)).toList();
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
