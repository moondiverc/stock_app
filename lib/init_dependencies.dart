import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:stock_app/features/news/data/datasources/news_remote_data_source.dart';
import 'package:stock_app/features/news/data/repositories/news_repository_impl.dart';
import 'package:stock_app/features/news/domain/repositories/news_repository.dart';
import 'package:stock_app/features/news/domain/usecases/get_all_news.dart';
import 'package:stock_app/features/news/presentation/cubit/news_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // http client (HARUS DIDAFTAR DULUAN)
  serviceLocator.registerSingleton<http.Client>(http.Client());

  // baru daftar news features
  _initNews();
}

void _initNews() {
  // data sources
  serviceLocator
    ..registerSingleton<NewsRemoteDataSource>(
      NewsRemoteDataSourceImpl(serviceLocator()),
    )
    // repositories
    ..registerSingleton<NewsRepository>(NewsRepositoryImpl(serviceLocator()))
    // use cases
    ..registerSingleton<GetAllNews>(GetAllNews(serviceLocator()))
    // bloc (cubits)
    ..registerSingleton<NewsCubit>(NewsCubit(serviceLocator()));
}
