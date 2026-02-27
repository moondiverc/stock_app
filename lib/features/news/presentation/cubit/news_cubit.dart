import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/core/usecase/usecase.dart';
import 'package:stock_app/features/news/domain/entities/news.dart';
import 'package:stock_app/features/news/domain/usecases/get_all_news.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final GetAllNews _getNewsUseCase;

  NewsCubit({required GetAllNews getNewsUseCase})
    : _getNewsUseCase = getNewsUseCase,
      super(NewsInitial());

  Future<void> getNews() async {
    emit(NewsLoading());

    final result = await _getNewsUseCase(NoParams());

    result.fold(
      (failure) => emit(NewsFailure(failure.message)),
      (newsList) => emit(NewsLoaded(newsList)),
    );
  }
}
