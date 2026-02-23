import 'package:stock_app/features/stock/domain/entities/stock.dart';

class StockModel extends Stock {
  const StockModel({
    required super.ticker,
    required super.price,
    required super.changeAmount,
    required super.changePercentage,
    required super.volume,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      ticker: json['ticker'] ?? '',
      price: json['price'] ?? '0.0',
      changeAmount: json['change_amount'] ?? '0.0',
      changePercentage: json['change_percentage'] ?? '0.0%',
      volume: json['volume'] ?? '0',
    );
  }

  // TODO: IMPLEMENT TOJSON UNTUK LOCAL
  Map<String, dynamic> toJson() {
    return {
      'ticker': ticker,
      'price': price,
      'change_amount': changeAmount,
      'change_percentage': changePercentage,
      'volume': volume,
    };
  }
}
