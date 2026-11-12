import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.isPassword = false,
    this.validator,
  });

  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.r),
      borderSide: const BorderSide(color: Color(0xFFEDEDED)),
    );

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscure,
      validator: widget.validator,
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        enabledBorder: border,
        border: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: Color(0xFFC4A052)),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscure ? Icons.visibility : Icons.visibility_off,
            size: 20.sp,
            color: Colors.black54,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        )
            : null,
      ),
    );
  }
}