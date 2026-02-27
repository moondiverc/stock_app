import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:stock_app/core/network/connection_checker.dart';
import 'package:stock_app/features/company/data/datasources/company_remote_data_source.dart';
import 'package:stock_app/features/company/data/datasources/company_local_data_source.dart';
import 'package:stock_app/features/company/data/repositories/company_repository_impl.dart';
import 'package:stock_app/features/company/domain/repositories/company_repository.dart';
import 'package:stock_app/features/company/domain/usecases/get_company.dart';
import 'package:stock_app/features/company/domain/usecases/get_company_trend.dart';
import 'package:stock_app/features/company/presentation/cubit/company_cubit.dart';
import 'package:stock_app/features/news/data/datasources/news_local_data_source.dart';
import 'package:stock_app/features/news/data/datasources/news_remote_data_source.dart';
import 'package:stock_app/features/news/data/repositories/news_repository_impl.dart';
import 'package:stock_app/features/news/domain/repositories/news_repository.dart';
import 'package:stock_app/features/news/domain/usecases/get_all_news.dart';
import 'package:stock_app/features/news/presentation/cubit/news_cubit.dart';
import 'package:stock_app/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:stock_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:stock_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:stock_app/features/profile/domain/usecases/get_profile.dart';
import 'package:stock_app/features/profile/domain/usecases/update_profile.dart';
import 'package:stock_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:stock_app/features/stock/data/datasources/stock_local_data_source.dart';
import 'package:stock_app/features/stock/data/datasources/stock_remote_data_sorce.dart';
import 'package:stock_app/features/stock/data/repositories/stock_repository_impl.dart';
import 'package:stock_app/features/stock/domain/repositories/stock_repository.dart';
import 'package:stock_app/features/stock/domain/usecases/get_all_stock.dart';
import 'package:stock_app/features/stock/presentation/cubit/stock_cubit.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // init Hive
  Hive.init((await getApplicationDocumentsDirectory()).path);

  // open box
  final stockBox = await Hive.openBox('stocks_box');
  final newsBox = await Hive.openBox('news_box');
  final companyBox = await Hive.openBox('company_box');
  final profileBox = await Hive.openBox('profile_box');

  // core dependencies
  serviceLocator.registerFactory(() => InternetConnection());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
  serviceLocator.registerSingleton<http.Client>(http.Client());

  // feature dependencies
  _initNews(newsBox);
  _initStock(stockBox);
  _initCompany(companyBox);
  _initProfile(profileBox);
}

void _initNews(Box box) {
  // data sources
  serviceLocator
    ..registerFactory<NewsRemoteDataSource>(
      () => NewsRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<NewsLocalDataSource>(() => NewsLocalDataSourceImpl(box))
    // repositories
    ..registerSingleton<NewsRepository>(
      NewsRepositoryImpl(serviceLocator(), serviceLocator(), serviceLocator()),
    )
    // use cases
    ..registerSingleton<GetAllNews>(GetAllNews(serviceLocator()))
    // bloc (cubits)
    ..registerSingleton<NewsCubit>(NewsCubit(serviceLocator()));
}

void _initStock(Box box) {
  // data sources
  serviceLocator
    ..registerFactory<StockRemoteDataSource>(
      () => StockRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<StockLocalDataSource>(() => StockLocalDataSourceImpl(box))
    // repositories
    ..registerSingleton<StockRepository>(
      StockRepositoryImpl(serviceLocator(), serviceLocator(), serviceLocator()),
    )
    // use cases
    ..registerSingleton<GetAllStock>(GetAllStock(serviceLocator()))
    // bloc (cubits)
    ..registerSingleton<StockCubit>(StockCubit(serviceLocator()));
}

void _initCompany(Box box) {
  // data sources
  serviceLocator
    ..registerSingleton<CompanyRemoteDataSource>(
      CompanyRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<CompanyLocalDataSource>(
      () => CompanyLocalDataSourceImpl(box),
    )
    // repositories
    ..registerSingleton<CompanyRepository>(
      CompanyRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // use cases
    ..registerSingleton<GetCompany>(GetCompany(serviceLocator()))
    ..registerSingleton<GetCompanyTrend>(GetCompanyTrend(serviceLocator()))
    // bloc (cubits)
    ..registerSingleton<CompanyCubit>(
      CompanyCubit(
        getCompanyUseCase: serviceLocator(),
        getCompanyTrendUseCase: serviceLocator(),
      ),
    );
}

void _initProfile(Box box) {
  // data sources
  serviceLocator
    ..registerFactory<ProfileLocalDataSource>(
      () => ProfileLocalDataSourceImpl(box),
    )
    // repositories
    ..registerSingleton<ProfileRepository>(
      ProfileRepositoryImpl(serviceLocator()),
    )
    // use cases
    ..registerSingleton<GetProfile>(GetProfile(serviceLocator()))
    ..registerSingleton<UpdateProfile>(UpdateProfile(serviceLocator()))
    // bloc (cubits)
    ..registerSingleton<ProfileCubit>(
      ProfileCubit(
        getProfile: serviceLocator(),
        updateProfile: serviceLocator(),
      ),
    );
}
