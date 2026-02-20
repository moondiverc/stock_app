part of 'news_cubit.dart';

@immutable
sealed class NewsState {}

final class NewsInitial extends NewsState {}

final class NewsLoading extends NewsState {}

final class NewsLoaded extends NewsState {
  final List<News> news;

  NewsLoaded(this.news);
}

final class NewsFailure extends NewsState {
  final String error;

  NewsFailure(this.error);
}
