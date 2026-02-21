import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  CompanyCubit() : super(CompanyInitial());
}
