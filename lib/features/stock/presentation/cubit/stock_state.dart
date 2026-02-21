part of 'stock_cubit.dart';

@immutable
sealed class StockState {}

final class StockInitial extends StockState {}

final class StockLoading extends StockState {}

final class StockLoaded extends StockState {
  final List<Stock> gainers;
  final List<Stock> losers;
  final List<Stock> actives;

  StockLoaded({
    required this.gainers,
    required this.losers,
    required this.actives,
  });
}

final class StockFailure extends StockState {
  final String error;

  StockFailure(this.error);
}
