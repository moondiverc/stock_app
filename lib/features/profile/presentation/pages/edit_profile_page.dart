import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_app/core/common/widgets/appbar.dart';
import 'package:stock_app/core/theme/app_pallete.dart';
import 'package:stock_app/features/profile/domain/entities/profile.dart';
import 'package:stock_app/features/profile/presentation/cubit/profile_cubit.dart';

class EditProfilePage extends StatefulWidget {
  final Profile profile;
  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _majorController;
  late TextEditingController _jobController;
  late TextEditingController _locationController;
  late TextEditingController _statusController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _ageController = TextEditingController(text: widget.profile.age);
    _majorController = TextEditingController(text: widget.profile.major);
    _jobController = TextEditingController(text: widget.profile.job);
    _locationController = TextEditingController(text: widget.profile.location);
    _statusController = TextEditingController(text: widget.profile.status);
    _descriptionController = TextEditingController(
      text: widget.profile.description,
    );
    _imageController = TextEditingController(text: widget.profile.profileImage);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _majorController.dispose();
    _jobController.dispose();
    _locationController.dispose();
    _statusController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final updatedProfile = Profile(
      name: _nameController.text,
      age: _ageController.text,
      major: _majorController.text,
      job: _jobController.text,
      location: _locationController.text,
      status: _statusController.text,
      description: _descriptionController.text,
      profileImage: _imageController.text,
    );

    context.read<ProfileCubit>().updateProfileData(updatedProfile);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StockAppBar(
        title: 'Edit Profile',
        subtitle: 'Update your details',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildTextField('Name', _nameController),
            _buildTextField('Age', _ageController),
            _buildTextField('Major (e.g. CS 2025)', _majorController),
            _buildTextField('Job (e.g. Active Trader)', _jobController),
            _buildTextField('Location', _locationController),
            _buildTextField('Status (e.g. Student)', _statusController),
            _buildTextField('Profile Image URL', _imageController),
            _buildTextField(
              'Description / Bio',
              _descriptionController,
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.themeColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
