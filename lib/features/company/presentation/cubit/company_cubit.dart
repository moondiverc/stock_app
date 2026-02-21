import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/features/company/domain/entities/company.dart';
import 'package:stock_app/features/company/domain/usecases/get_company.dart';

part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final GetCompany _getCompanyUseCase;

  CompanyCubit(this._getCompanyUseCase) : super(CompanyInitial());

  Future<void> getCompanyData(String ticker) async {
    emit(CompanyLoading());

    final result = await _getCompanyUseCase(ticker);

    result.fold(
      (failure) => emit(CompanyFailure(failure.message)),
      (company) => emit(CompanyLoaded(company)),
    );
  }
}
