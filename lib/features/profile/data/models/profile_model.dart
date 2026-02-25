import 'package:stock_app/features/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.name,
    required super.age,
    required super.major,
    required super.job,
    required super.location,
    required super.status,
    required super.description,
    required super.profileImage,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] ?? '',
      age: json['age'] ?? '',
      major: json['major'] ?? '',
      job: json['job'] ?? '',
      location: json['location'] ?? '',
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'major': major,
      'job': job,
      'location': location,
      'status': status,
      'description': description,
      'profileImage': profileImage,
    };
  }

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      name: profile.name,
      age: profile.age,
      major: profile.major,
      job: profile.job,
      location: profile.location,
      status: profile.status,
      description: profile.description,
      profileImage: profile.profileImage,
    );
  }
}
