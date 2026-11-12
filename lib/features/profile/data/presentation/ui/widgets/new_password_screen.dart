import 'package:app3/core/widget/app_text_feild.dart';
import 'package:app3/core/widget/custom_back_button.dart';
import 'package:app3/core/widget/primary_button_profile.dart';
import 'package:app3/features/profile/data/presentation/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ضعه في: features/profile/data/presentation/ui/new_password_screen.dart
class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onUpdate() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProfileCubit>().changePassword(
      currentPassword: _currentController.text,
      newPassword: _newController.text,
      confirmPassword: _confirmController.text,
    );
  }

  String? _required(String? v) =>
      (v == null || v.isEmpty) ? "This field is required" : null;

  String? _newPasswordValidator(String? v) {
    if (v == null || v.isEmpty) return "This field is required";
    if (v.length < 8) return "Password must be at least 8 characters";
    return null;
  }

  String? _confirmValidator(String? v) {
    if (v == null || v.isEmpty) return "This field is required";
    if (v != _newController.text) return "Passwords do not match";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password updated successfully")),
          );
          Navigator.pop(context);
        } else if (state is ChangePasswordError) {
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
                SizedBox(
                  height: 56.h,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: CustomBackButton(),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          32.verticalSpace,
                          Text(
                            "New Password",
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          48.verticalSpace,
                          AppTextField(
                            hint: "Current Password",
                            controller: _currentController,
                            isPassword: true,
                            validator: _required,
                          ),
                          14.verticalSpace,
                          AppTextField(
                            hint: "New Password",
                            controller: _newController,
                            isPassword: true,
                            validator: _newPasswordValidator,
                          ),
                          14.verticalSpace,
                          AppTextField(
                            hint: "Confirm password",
                            controller: _confirmController,
                            isPassword: true,
                            validator: _confirmValidator,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                12.verticalSpace,
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) => PrimaryButton(
                    text: "Update Password",
                    isLoading: state is ChangePasswordLoading,
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