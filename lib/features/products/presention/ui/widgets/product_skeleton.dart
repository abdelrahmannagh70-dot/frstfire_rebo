import 'package:app3/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductSkeletonLoading extends StatelessWidget {
  const ProductSkeletonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.62,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 14.h,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 11,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(14.r),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 60.w,
                              height: 10.h,
                              color: Colors.grey.shade300,
                            ),
                            6.verticalSpace,
                            Container(
                              width: double.infinity,
                              height: 14.h,
                              color: Colors.grey.shade300,
                            ),
                            4.verticalSpace,
                            Container(
                              width: 80.w,
                              height: 14.h,
                              color: Colors.grey.shade300,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 50.w,
                              height: 16.h,
                              color: Colors.grey.shade300,
                            ),
                            Container(
                              width: 28.w,
                              height: 28.w,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
