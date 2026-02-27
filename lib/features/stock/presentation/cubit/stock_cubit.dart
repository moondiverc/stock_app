import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/core/usecase/usecase.dart';
import 'package:stock_app/features/stock/domain/entities/stock.dart';
import 'package:stock_app/features/stock/domain/usecases/get_all_stock.dart';

part 'stock_state.dart';

class StockCubit extends Cubit<StockState> {
  final GetAllStock _getStocksUseCase;

  StockCubit({required GetAllStock getStocksUseCase})
    : _getStocksUseCase = getStocksUseCase,
      super(StockInitial());

  Future<void> getStocks() async {
    emit(StockLoading());

    final result = await _getStocksUseCase(NoParams());

    result.fold(
      (failure) => emit(StockFailure(failure.message)),
      (marketData) => emit(
        StockLoaded(
          gainers: marketData.gainers,
          losers: marketData.losers,
          actives: marketData.actives,
        ),
      ),
    );
  }
}
