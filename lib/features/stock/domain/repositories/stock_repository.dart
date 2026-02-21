import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/features/stock/domain/entities/stock_category.dart';

abstract interface class StockRepository {
  Future<Either<Failure, StockCategory>> getStocks();
}
