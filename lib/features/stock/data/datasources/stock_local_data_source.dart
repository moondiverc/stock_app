import 'package:hive/hive.dart';
import 'package:stock_app/core/error/exceptions.dart';
import 'package:stock_app/features/stock/data/models/stock_model.dart';
import 'package:stock_app/features/stock/domain/entities/stock_category.dart';

abstract interface class StockLocalDataSource {
  void cacheStockCategory(
    List<StockModel> gainers,
    List<StockModel> losers,
    List<StockModel> actives,
  );

  StockCategory loadStockCategory();
}

class StockLocalDataSourceImpl implements StockLocalDataSource {
  final Box box;

  StockLocalDataSourceImpl(this.box);

  @override
  void cacheStockCategory(
    List<StockModel> gainers,
    List<StockModel> losers,
    List<StockModel> actives,
  ) {
    try {
      box.put('gainers', gainers.map((e) => e.toJson()).toList());
      box.put('losers', losers.map((e) => e.toJson()).toList());
      box.put('actives', actives.map((e) => e.toJson()).toList());
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  StockCategory loadStockCategory() {
    List<StockModel> getList(String key) {
      final data = box.get(key);
      if (data != null) {
        try {
          return List<dynamic>.from(data)
              .map((e) => StockModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } catch (_) {
          return [];
        }
      }
      return [];
    }

    final gainers = getList('gainers');
    final losers = getList('losers');
    final actives = getList('actives');

    if (gainers.isEmpty && losers.isEmpty && actives.isEmpty) {
      throw CacheException();
    }

    return StockCategory(gainers: gainers, losers: losers, actives: actives);
  }
}
