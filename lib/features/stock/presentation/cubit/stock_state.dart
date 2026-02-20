part of 'stock_cubit.dart';

@immutable
sealed class StockState {}

final class StockInitial extends StockState {}

final class StockLoading extends StockState {}

final class StockLoaded extends StockState {
  final List<Stock> stocks;

  StockLoaded(this.stocks);
}

final class StockFailure extends StockState {
  final String error;

  StockFailure(this.error);
}
