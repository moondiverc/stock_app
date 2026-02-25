import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_app/core/usecase/usecase.dart';
import 'package:stock_app/features/profile/domain/entities/profile.dart';
import 'package:stock_app/features/profile/domain/usecases/get_profile.dart';
import 'package:stock_app/features/profile/domain/usecases/update_profile.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;

  ProfileCubit({
    required GetProfile getProfile,
    required UpdateProfile updateProfile,
  }) : _getProfile = getProfile,
       _updateProfile = updateProfile,
       super(ProfileInitial());

  /// Load data profil dari Local Storage (Hive)
  Future<void> loadProfile() async {
    emit(ProfileLoading());

    final result = await _getProfile(NoParams());

    result.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  /// Update data profil ke Local Storage
  Future<void> updateProfileData(Profile newProfile) async {
    emit(ProfileLoading());

    final result = await _updateProfile(newProfile);

    result.fold((failure) => emit(ProfileFailure(failure.message)), (_) {
      // Jika sukses update, panggil loadProfile lagi
      // agar state UI diperbarui dengan data yang baru disimpan
      loadProfile();
    });
  }
}
