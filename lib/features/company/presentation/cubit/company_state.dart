part of 'company_cubit.dart';

@immutable
sealed class CompanyState {}

final class CompanyInitial extends CompanyState {}

final class CompanyLoading extends CompanyState {}

final class CompanyLoaded extends CompanyState {
  final Company company;

  CompanyLoaded(this.company);
}

final class CompanyFailure extends CompanyState {
  final String error;

  CompanyFailure(this.error);
}
