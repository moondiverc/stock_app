import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/features/company/domain/entities/company.dart';

abstract interface class CompanyRepository {
  Future<Either<Failure, Company>> getCompany(String ticker);
  Future<Either<Failure, List<double>>> getHistoricalPrices(String ticker);
}
