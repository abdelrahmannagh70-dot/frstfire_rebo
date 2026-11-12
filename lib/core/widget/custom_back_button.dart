import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.maybePop(context),
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: 40.h,
        width: 40.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFEDEDED)),
        ),
        child: Icon(Icons.arrow_back_ios_new_rounded, size: 16.sp),
      ),
    );
  }
}