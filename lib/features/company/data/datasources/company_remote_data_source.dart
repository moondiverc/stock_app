import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';
import 'package:stock_app/core/error/exceptions.dart';
import 'package:stock_app/core/secret/app_secrets.dart';
import 'package:stock_app/features/company/data/models/company_model.dart';

abstract interface class CompanyRemoteDataSource {
  Future<CompanyModel> getCompany(String symbol);
  Future<bool> getIsTrendUp(String symbol);
  Future<List<double>> getHistoricalPrices(String symbol);
}

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  final http.Client client;

  CompanyRemoteDataSourceImpl(this.client);

  @override
  Future<CompanyModel> getCompany(String symbol) async {
    try {
      final response = await client.get(
        Uri.parse(
          'https://www.alphavantage.co/query?function=OVERVIEW&symbol=$symbol&apikey=${AppSecrets.apiKey}',
        ),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('Note') || data.containsKey('Information')) {
          throw ServerException(data['Note'] ?? data['Information']);
        }
        return CompanyModel.fromJson(data);
      } else {
        throw ServerException('Failed to connect to server');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> getIsTrendUp(String symbol) async {
    try {
      final YahooFinanceResponse response =
          await const YahooFinanceDailyReader().getDailyDTOs(symbol);

      final List<YahooFinanceCandleData> historicalData = response.candlesData;

      if (historicalData.isEmpty || historicalData.length < 2) {
        return true;
      }

      final double latestClose = historicalData.last.close;
      final double previousClose =
          historicalData[historicalData.length - 2].close;

      return latestClose >= previousClose;
    } catch (e) {
      return true;
    }
  }

  @override
  Future<List<double>> getHistoricalPrices(String symbol) async {
    try {
      final response = await const YahooFinanceDailyReader().getDailyDTOs(
        symbol,
      );

      if (response.candlesData.isEmpty) {
        return [];
      }

      return response.candlesData.reversed
          .take(10)
          .map((e) => e.close)
          .toList()
          .reversed
          .toList();
    } catch (e) {
      return [];
    }
  }
}
