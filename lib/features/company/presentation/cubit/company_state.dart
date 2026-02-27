part of 'company_cubit.dart';

@immutable
sealed class CompanyState {}

final class CompanyInitial extends CompanyState {}

final class CompanyLoading extends CompanyState {}

final class CompanyLoaded extends CompanyState {
  final Company company;
  final List<double> historicalPrices;
  final bool isTrendUp;

  CompanyLoaded(this.company, this.historicalPrices, this.isTrendUp);
}

final class CompanyFailure extends CompanyState {
  final String error;

  CompanyFailure(this.error);
}
