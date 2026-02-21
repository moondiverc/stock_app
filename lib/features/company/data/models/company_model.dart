import 'package:stock_app/features/company/domain/entities/company.dart';

class CompanyModel extends Company {
  const CompanyModel({
    required super.symbol,
    required super.name,
    required super.description,
    required super.marketCap,
    required super.peRatio,
    required super.dividendYield,
    required super.sector,
    required super.website,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      symbol: json['Symbol'] ?? '',
      name: json['Name'] ?? 'Unknown Company',
      description: json['Description'] ?? 'No description available.',
      marketCap: json['MarketCapitalization'] == 'None'
          ? '-'
          : (json['MarketCapitalization'] ?? '-'),
      peRatio: json['PERatio'] == 'None' ? '-' : (json['PERatio'] ?? '-'),
      dividendYield: json['DividendYield'] == 'None'
          ? '-'
          : (json['DividendYield'] ?? '-'),
      sector: json['Sector'] ?? '-',
      website:
          json['OfficialSite'] ??
          'https://www.google.com/search?q=${json["Name"] ?? json["Symbol"]}',
    );
  }
}
