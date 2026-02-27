import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/exceptions.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/core/network/connection_checker.dart';
import 'package:stock_app/features/company/data/datasources/company_remote_data_source.dart';
import 'package:stock_app/features/company/data/datasources/company_local_data_source.dart';
import 'package:stock_app/features/company/domain/entities/company.dart';
import 'package:stock_app/features/company/domain/repositories/company_repository.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDataSource companyRemoteDataSource;
  final CompanyLocalDataSource companyLocalDataSource;
  final ConnectionChecker connectionChecker;

  CompanyRepositoryImpl(
    this.companyRemoteDataSource,
    this.companyLocalDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, Company>> getCompany(String ticker) async {
    try {
      if (!await connectionChecker.isConnected) {
        try {
          final localCompany = await companyLocalDataSource.loadCompany(ticker);
          return right(localCompany);
        } catch (e) {
          return left(Failure('No internet and no cached data for $ticker'));
        }
      }

      final remoteCompany = await companyRemoteDataSource.getCompany(ticker);

      try {
        await companyLocalDataSource.cacheCompany(remoteCompany);
      } on CacheException {}

      return right(remoteCompany);
    } on ServerException {
      try {
        final localCompany = await companyLocalDataSource.loadCompany(ticker);
        return right(localCompany);
      } catch (e) {
        return left(Failure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<double>>> getHistoricalPrices(
    String ticker,
  ) async {
    try {
      final prices = await companyRemoteDataSource.getHistoricalPrices(ticker);
      return right(prices);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
