import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'stock_state.dart';

class StockCubit extends Cubit<StockState> {
  StockCubit() : super(StockInitial());
}
