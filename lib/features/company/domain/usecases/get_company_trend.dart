import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/core/usecase/usecase.dart';
import 'package:stock_app/features/company/domain/repositories/company_repository.dart';

class GetCompanyTrend implements UseCase<List<double>, String> {
  final CompanyRepository companyRepository;
  GetCompanyTrend(this.companyRepository);

  @override
  Future<Either<Failure, List<double>>> call(String ticker) async {
    return await companyRepository.getHistoricalPrices(ticker);
  }
}
