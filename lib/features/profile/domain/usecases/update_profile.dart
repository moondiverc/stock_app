import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/core/usecase/usecase.dart';
import 'package:stock_app/features/profile/domain/entities/profile.dart';
import 'package:stock_app/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfile implements UseCase<void, Profile> {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, void>> call(Profile params) async {
    return await repository.updateProfile(params);
  }
}
