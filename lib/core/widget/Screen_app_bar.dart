import 'package:app3/core/widget/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAppBar extends StatelessWidget {
  const ScreenAppBar({super.key, required this.title});

  final String title;

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
            title,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}