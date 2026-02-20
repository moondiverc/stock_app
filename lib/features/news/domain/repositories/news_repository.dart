import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/features/news/domain/entities/news.dart';

abstract interface class NewsRepository {
  Future<Either<Failure, List<News>>> getNews();
}
