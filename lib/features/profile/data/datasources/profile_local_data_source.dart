import 'package:hive/hive.dart';
import 'package:stock_app/core/error/exceptions.dart';
import 'package:stock_app/features/profile/data/models/profile_model.dart';

abstract interface class ProfileLocalDataSource {
  Future<ProfileModel> getProfile();
  Future<void> saveProfile(ProfileModel profile);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final Box box;
  static const String _key = 'my_profile_v2';

  ProfileLocalDataSourceImpl(this.box);

  @override
  Future<ProfileModel> getProfile() async {
    final data = box.get(_key);
    if (data != null) {
      try {
        final map = Map<String, dynamic>.from(data as Map);
        return ProfileModel.fromJson(map);
      } catch (e) {
        throw CacheException();
      }
    } else {
      return const ProfileModel(
        name: 'Nezzaluna Azzahra',
        age: '19',
        major: 'Computer Science 2024',
        job: 'Software Engineer',
        location: 'Depok',
        status: 'Student',
        description:
            'Computer Science @ CSUI. Passionate about Software Engineering, Supply-Chain Management, and Data Analytics. Always eager to learn and grow in the tech world.',
        profileImage:
            'https://scontent-cgk2-1.cdninstagram.com/v/t51.2885-19/341582038_116913958039383_3577303180316132013_n.jpg?efg=eyJ2ZW5jb2RlX3RhZyI6InByb2ZpbGVfcGljLmRqYW5nby44NjQuYzIifQ&_nc_ht=scontent-cgk2-1.cdninstagram.com&_nc_cat=103&_nc_oc=Q6cZ2QEZDs9QIf9mtXusPmjBZ6EOQ39J8PrQOBILjXf1zPq1mIWskkddjRk99ewAk6btlQI&_nc_ohc=8YEyGPOhZBMQ7kNvwE4taB1&_nc_gid=KIbx1urT0DJ61WhNx-3y7w&edm=ALGbJPMBAAAA&ccb=7-5&oh=00_AfvCwvYay-3NPDMOP3muAs83boDLo6Vim4Wkod4BUqWdtQ&oe=69A4552B&_nc_sid=7d3ac5',
      );
    }
  }

  @override
  Future<void> saveProfile(ProfileModel profile) async {
    await box.put(_key, profile.toJson());
  }
}
