import 'package:hive/hive.dart';
import 'package:stock_app/core/error/exceptions.dart';
import '../models/news_model.dart';

abstract interface class NewsLocalDataSource {
  Future<void> uploadNews(List<NewsModel> newsList);
  List<NewsModel> loadNews();
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final Box box;

  NewsLocalDataSourceImpl(this.box);

  @override
  List<NewsModel> loadNews() {
    List<NewsModel> newsList = [];

    if (box.isEmpty) {
      throw CacheException();
    }

    for (int i = 0; i < box.length; i++) {
      final newsJson = box.get(i.toString());

      if (newsJson != null) {
        try {
          final newsMap = Map<String, dynamic>.from(newsJson as Map);
          newsList.add(NewsModel.fromJson(newsMap));
        } on TypeError catch (_) {
          continue;
        } catch (_) {
          continue;
        }
      }
    }

    if (newsList.isEmpty) {
      throw CacheException();
    }

    return newsList;
  }

  @override
  Future<void> uploadNews(List<NewsModel> newsList) async {
    try {
      await box.clear();

      for (int i = 0; i < newsList.length; i++) {
        await box.put(i.toString(), newsList[i].toJson());
      }
    } catch (e) {
      throw CacheException();
    }
  }
}
