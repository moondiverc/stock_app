import 'stock.dart';

class StockCategory {
  final List<Stock> gainers;
  final List<Stock> losers;
  final List<Stock> actives;

  StockCategory({
    required this.gainers,
    required this.losers,
    required this.actives,
  });
}
