import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/features/company/domain/entities/company.dart';
import 'package:stock_app/features/company/domain/usecases/get_company.dart';
import 'package:stock_app/features/company/domain/usecases/get_company_trend.dart';

part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final GetCompany _getCompanyUseCase;
  final GetCompanyTrend _getCompanyTrendUseCase;

  CompanyCubit({
    required GetCompany getCompanyUseCase,
    required GetCompanyTrend getCompanyTrendUseCase,
  }) : _getCompanyUseCase = getCompanyUseCase,
       _getCompanyTrendUseCase = getCompanyTrendUseCase,
       super(CompanyInitial());

  Future<void> getCompanyData(String ticker) async {
    emit(CompanyLoading());

    final results = await Future.wait([
      _getCompanyUseCase(ticker),
      _getCompanyTrendUseCase(ticker),
    ]);

    final companyResult = results[0] as Either<Failure, Company>;
    final trendResult = results[1] as Either<Failure, List<double>>;

    companyResult.fold((failure) => emit(CompanyFailure(failure.message)), (
      company,
    ) {
      trendResult.fold((failure) => emit(CompanyLoaded(company, [], true)), (
        prices,
      ) {
        // Tentukan tren berdasarkan harga awal dan akhir di list
        bool isUp = false;
        if (prices.isNotEmpty && prices.length >= 2) {
          isUp = prices.last >= prices.first;
        }
        emit(CompanyLoaded(company, prices, isUp));
      });
    });
  }
}
