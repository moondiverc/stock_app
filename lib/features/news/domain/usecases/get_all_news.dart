import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/core/usecase/usecase.dart';
import 'package:stock_app/features/news/domain/entities/news.dart';
import 'package:stock_app/features/news/domain/repositories/news_repository.dart';

class GetAllNews implements UseCase<List<News>, NoParams> {
  final NewsRepository newsRepository;

  GetAllNews(this.newsRepository);

  @override
  Future<Either<Failure, List<News>>> call(NoParams params) async {
    return await newsRepository.getNews();
  }
}
