import 'dart:io';

import 'package:app3/core/widget/app_text_feild.dart';
import 'package:app3/core/widget/custom_back_button.dart';
import 'package:app3/core/widget/primary_button_profile.dart';
import 'package:app3/features/profile/data/presentation/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();

  File? _pickedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    // if (picked != null) setState(() => _pickedImage = File(picked.path));
  }

  void _onUpdate() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProfileCubit>().updateProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      city: _cityController.text.trim(),
      address: _addressController.text.trim(),
      image: _pickedImage,
    );
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? "This field is required" : null;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is UpdateProfileSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated")),
          );
          Navigator.pop(context);
        } else if (state is UpdateProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                const _EditProfileAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          24.verticalSpace,
                          _AvatarPicker(image: _pickedImage, onTap: _pickImage),
                          32.verticalSpace,
                          AppTextField(
                            hint: "Full Name",
                            controller: _nameController,
                            validator: _required,
                          ),
                          14.verticalSpace,
                          AppTextField(
                            hint: "Phone",
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validator: _required,
                          ),
                          14.verticalSpace,
                          AppTextField(
                            hint: "City",
                            controller: _cityController,
                            validator: _required,
                          ),
                          14.verticalSpace,
                          AppTextField(
                            hint: "Address",
                            controller: _addressController,
                            validator: _required,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                12.verticalSpace,
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) => PrimaryButton(
                    text: "Update Profile",
                    isLoading: state is UpdateProfileLoading,
                    onPressed: _onUpdate,
                  ),
                ),
                16.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditProfileAppBar extends StatelessWidget {
  const _EditProfileAppBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: CustomBackButton(),
          ),
          Text(
            "Edit Profile",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  const _AvatarPicker({required this.image, required this.onTap});

  final File? image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60.r,
          backgroundColor: const Color(0xFFE0E0E0),
          backgroundImage: image != null ? FileImage(image!) : null,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEDEDED)),
              ),
              child: Icon(
                Icons.photo_camera_outlined,
                size: 18.sp,
                color: const Color(0xFFC4A052),
              ),
            ),
          ),
        ),
      ],
    );
  }
}