import 'package:hive/hive.dart';
import 'package:stock_app/core/error/exceptions.dart';
import 'package:stock_app/features/company/data/models/company_model.dart';

abstract interface class CompanyLocalDataSource {
  Future<void> cacheCompany(CompanyModel company);
  Future<CompanyModel> loadCompany(String ticker);
}

class CompanyLocalDataSourceImpl implements CompanyLocalDataSource {
  final Box box;

  CompanyLocalDataSourceImpl(this.box);

  @override
  Future<CompanyModel> loadCompany(String ticker) async {
    final json = box.get(ticker);

    if (json != null) {
      try {
        final map = Map<String, dynamic>.from(json as Map);
        return CompanyModel.fromJson(map);
      } catch (e) {
        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheCompany(CompanyModel company) async {
    await box.put(company.symbol, company.toJson());
  }
}
