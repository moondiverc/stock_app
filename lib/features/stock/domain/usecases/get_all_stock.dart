import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/core/usecase/usecase.dart';
import 'package:stock_app/features/stock/domain/entities/stock.dart';
import 'package:stock_app/features/stock/domain/repositories/stock_repository.dart';

class GetAllStock implements UseCase<List<Stock>, NoParams> {
  final StockRepository stockRepository;

  GetAllStock(this.stockRepository);

  @override
  Future<Either<Failure, List<Stock>>> call(NoParams params) async {
    return await stockRepository.getStocks();
  }
}
