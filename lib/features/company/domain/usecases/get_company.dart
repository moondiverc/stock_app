import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/core/usecase/usecase.dart';
import 'package:stock_app/features/company/domain/entities/company.dart';
import 'package:stock_app/features/company/domain/repositories/company_repository.dart';

class GetCompany implements UseCase<Company, String> {
  final CompanyRepository companyRepository;

  GetCompany(this.companyRepository);

  @override
  Future<Either<Failure, Company>> call(String ticker) async {
    return await companyRepository.getCompany(ticker);
  }
}
