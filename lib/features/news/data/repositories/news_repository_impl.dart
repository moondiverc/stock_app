import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/exceptions.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/core/network/connection_checker.dart';
import 'package:stock_app/features/news/data/datasources/news_local_data_source.dart';
import 'package:stock_app/features/news/data/datasources/news_remote_data_source.dart';
import 'package:stock_app/features/news/data/models/news_model.dart';
import 'package:stock_app/features/news/domain/entities/news.dart';
import 'package:stock_app/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource newsRemoteDataSource;
  final NewsLocalDataSource newsLocalDataSource;
  final ConnectionChecker connectionChecker;

  NewsRepositoryImpl(
    this.newsRemoteDataSource,
    this.newsLocalDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, List<News>>> getNews() async {
    try {
      if (!await connectionChecker.isConnected) {
        try {
          final localNews = newsLocalDataSource.loadNews();
          return right(localNews);
        } catch (e) {
          return left(Failure('No internet and no cached news found'));
        }
      }

      final remoteNews = await newsRemoteDataSource.getNews();

      try {
        await newsLocalDataSource.uploadNews(remoteNews.cast<NewsModel>());
      } on CacheException {
        // cache ecxeption
      }

      return right(remoteNews);
    } on ServerException catch (e) {
      try {
        final localNews = newsLocalDataSource.loadNews();
        return right(localNews);
      } catch (_) {
        return left(Failure(e.message));
      }
    }
  }
}
