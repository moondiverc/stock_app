import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/exceptions.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/features/news/data/datasources/news_remote_data_source.dart';
import 'package:stock_app/features/news/domain/entities/news.dart';
import 'package:stock_app/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource newsRemoteDataSource;

  NewsRepositoryImpl(this.newsRemoteDataSource);

  @override
  Future<Either<Failure, List<News>>> getNews() async {
    try {
      // TODO: implement caching + local data source

      final news = await newsRemoteDataSource.getNews();
      return right(news);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
