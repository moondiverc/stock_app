part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final Profile profile;

  ProfileLoaded(this.profile);
}

final class ProfileFailure extends ProfileState {
  final String error;

  ProfileFailure(this.error);
}
