import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/exceptions.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/features/company/data/datasources/company_data_source.dart';
import 'package:stock_app/features/company/domain/entities/company.dart';
import 'package:stock_app/features/company/domain/repositories/company_repository.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDataSource companyRemoteDataSource;

  CompanyRepositoryImpl(this.companyRemoteDataSource);

  @override
  Future<Either<Failure, Company>> getCompany(String ticker) async {
    try {
      // TODO: implement caching + local data source

      final company = await companyRemoteDataSource.getCompany(ticker);
      return right(company);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
