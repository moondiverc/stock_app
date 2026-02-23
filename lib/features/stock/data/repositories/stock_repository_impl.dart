import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/exceptions.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/core/network/connection_checker.dart';
import 'package:stock_app/features/stock/data/datasources/stock_local_data_source.dart';
import 'package:stock_app/features/stock/data/datasources/stock_remote_data_sorce.dart';
import 'package:stock_app/features/stock/data/models/stock_model.dart';
import 'package:stock_app/features/stock/domain/entities/stock_category.dart';
import 'package:stock_app/features/stock/domain/repositories/stock_repository.dart';

class StockRepositoryImpl implements StockRepository {
  final StockRemoteDataSource stockRemoteDataSource;
  final StockLocalDataSource stockLocalDataSource;
  final ConnectionChecker connectionChecker;

  StockRepositoryImpl(
    this.stockRemoteDataSource,
    this.stockLocalDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, StockCategory>> getStocks() async {
    try {
      if (!await connectionChecker.isConnected) {
        try {
          final localStocks = stockLocalDataSource.loadStockCategory();
          return right(localStocks);
        } catch (e) {
          return left(Failure('No internet and no cached data'));
        }
      }

      final remoteStocks = await stockRemoteDataSource.getStocks();

      stockLocalDataSource.cacheStockCategory(
        remoteStocks.gainers.cast<StockModel>(),
        remoteStocks.losers.cast<StockModel>(),
        remoteStocks.actives.cast<StockModel>(),
      );

      return right(remoteStocks);
    } on ServerException catch (e) {
      try {
        final localStocks = stockLocalDataSource.loadStockCategory();
        return right(localStocks);
      } catch (_) {
        return left(Failure(e.message));
      }
    }
  }
}
