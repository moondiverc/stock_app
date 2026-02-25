import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:stock_app/features/profile/data/models/profile_model.dart';
import 'package:stock_app/features/profile/domain/entities/profile.dart';
import 'package:stock_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;
  ProfileRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, Profile>> getProfile() async {
    try {
      final profile = await localDataSource.getProfile();
      return right(profile);
    } catch (e) {
      return left(Failure('Failed to load profile'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(Profile profile) async {
    try {
      final model = ProfileModel.fromEntity(profile);
      await localDataSource.saveProfile(model);
      return right(null);
    } catch (e) {
      return left(Failure('Failed to save profile'));
    }
  }
}
