import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/features/stock/domain/entities/stock.dart';

abstract interface class StockRepository {
  Future<Either<Failure, List<Stock>>> getStocks();
}
