import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/core/usecase/usecase.dart';
import 'package:stock_app/features/stock/domain/entities/stock_category.dart';
import 'package:stock_app/features/stock/domain/repositories/stock_repository.dart';

class GetAllStock implements UseCase<StockCategory, NoParams> {
  final StockRepository stockRepository;

  GetAllStock(this.stockRepository);

  @override
  Future<Either<Failure, StockCategory>> call(NoParams params) async {
    return await stockRepository.getStocks();
  }
}
