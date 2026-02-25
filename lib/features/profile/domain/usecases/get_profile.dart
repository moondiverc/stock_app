import 'package:fpdart/fpdart.dart';
import 'package:stock_app/core/error/failures.dart';
import 'package:stock_app/core/usecase/usecase.dart';
import 'package:stock_app/features/profile/domain/entities/profile.dart';
import 'package:stock_app/features/profile/domain/repositories/profile_repository.dart';

class GetProfile implements UseCase<Profile, NoParams> {
  final ProfileRepository repository;

  GetProfile(this.repository);

  @override
  Future<Either<Failure, Profile>> call(NoParams params) async {
    return await repository.getProfile();
  }
}
