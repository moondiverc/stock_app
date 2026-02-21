import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stock_app/core/error/exceptions.dart';
import 'package:stock_app/core/secret/app_secrets.dart';
import 'package:stock_app/features/company/data/models/company_model.dart';

abstract interface class CompanyRemoteDataSource {
  Future<CompanyModel> getCompany(String symbol);
}

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  final http.Client client;

  CompanyRemoteDataSourceImpl(this.client);

  @override
  Future<CompanyModel> getCompany(String symbol) async {
    try {
      final response = await client.get(
        Uri.parse(
          'https://www.alphavantage.co/query?function=OVERVIEW&symbol=${symbol}&apikey=${AppSecrets.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('Note') || data.containsKey('Information')) {
          throw ServerException(data['Note'] ?? data['Information']);
        }

        return CompanyModel.fromJson(data);
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
