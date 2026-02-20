import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/exceptions.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/features/stock/data/datasources/stock_remote_data_sorce.dart';
import 'package:stock_app/features/stock/domain/entities/stock.dart';
import 'package:stock_app/features/stock/domain/repositories/stock_repository.dart';

class StockRepositoryImpl implements StockRepository {
  final StockRemoteDataSource stockRemoteDataSource;

  StockRepositoryImpl(this.stockRemoteDataSource);

  @override
  Future<Either<Failure, List<Stock>>> getStocks() async {
    try {
      // TODO: implement caching + local data source

      final stocks = await stockRemoteDataSource.getStocks();
      return right(stocks);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
