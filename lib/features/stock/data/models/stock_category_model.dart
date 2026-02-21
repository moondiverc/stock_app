import 'package:stock_app/features/stock/domain/entities/stock_category.dart';
import 'stock_model.dart';

class StockCategoryModel extends StockCategory {
  StockCategoryModel({
    required super.gainers,
    required super.losers,
    required super.actives,
  });

  factory StockCategoryModel.fromJson(Map<String, dynamic> json) {
    List<StockModel> parseList(String key) {
      if (json[key] != null && json[key] is List) {
        return (json[key] as List)
            .map((item) => StockModel.fromJson(item))
            .toList();
      }
      return [];
    }

    return StockCategoryModel(
      gainers: parseList('top_gainers'),
      losers: parseList('top_losers'),
      actives: parseList('most_actively_traded'),
    );
  }
}
