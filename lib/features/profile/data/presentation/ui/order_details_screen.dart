import 'package:app3/core/themes/app_colors.dart';
import 'package:app3/features/profile/data/presentation/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/order_details_model.dart';
import 'widgets/order_item_tile.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          buildWhen: (_, s) =>
              s is GetOrderDetailsLoading ||
              s is GetOrderDetailsSuccess ||
              s is GetOrderDetailsError,
          builder: (context, state) {
            if (state is GetOrderDetailsLoading) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.mainColor),
              );
            } else if (state is GetOrderDetailsSuccess) {
              return _Body(details: state.details);
            } else if (state is GetOrderDetailsError) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(10.r),
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.borderColor),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(Icons.arrow_back_ios_new, size: 16.sp),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 48.sp,
                              color: const Color(0xFFE53935),
                            ),
                            16.verticalSpace,
                            Text(
                              "Failed to Load Order Details",
                              style: TextStyle(
                                fontFamily: 'DM',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            8.verticalSpace,
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.darkGrayColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(color: AppColors.mainColor),
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final OrderDetailsModel details;
  const _Body({required this.details});

  @override
  Widget build(BuildContext context) {
    final code = details.orderCode.trim();
    final displayCode = code.startsWith('#') ? code : '#$code';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          12.verticalSpace,
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(10.r),
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(Icons.arrow_back_ios_new, size: 16.sp),
                ),
              ),
              const Spacer(),
              Text(
                displayCode,
                style: TextStyle(
                  fontFamily: 'DM',
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              SizedBox(width: 36.w),
            ],
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                20.verticalSpace,
                Text(
                  "Delivery Address",
                  style: TextStyle(
                    fontFamily: 'DM',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                12.verticalSpace,
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: AppColors.bgColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person_outline, size: 16.sp, color: AppColors.mainColor),
                          6.horizontalSpace,
                          Text(
                            details.name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      6.verticalSpace,
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 16.sp, color: AppColors.grayColor),
                          6.horizontalSpace,
                          Expanded(
                            child: Text(
                              "${details.address}, ${details.governorate}",
                              style: TextStyle(fontSize: 12.sp, color: AppColors.darkGrayColor),
                            ),
                          ),
                        ],
                      ),
                      6.verticalSpace,
                      Row(
                        children: [
                          Icon(Icons.phone_outlined, size: 16.sp, color: AppColors.grayColor),
                          6.horizontalSpace,
                          Text(
                            details.phone,
                            style: TextStyle(fontSize: 12.sp, color: AppColors.darkGrayColor),
                          ),
                        ],
                      ),
                      if (details.notes != null && details.notes!.isNotEmpty) ...[
                        8.verticalSpace,
                        Text(
                          "Note: ${details.notes}",
                          style: TextStyle(fontSize: 12.sp, color: AppColors.grayColor),
                        ),
                      ],
                    ],
                  ),
                ),
                16.verticalSpace,
                Divider(color: AppColors.borderColor),
                10.verticalSpace,
                Text(
                  "Items (${details.products.length})",
                  style: TextStyle(
                    fontFamily: 'DM',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...details.products.map((e) => OrderItemTile(item: e)),
                14.verticalSpace,
                if (details.discount > 0)
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      border: Border.all(color: const Color(0xFFA5D6A7)),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_offer_outlined,
                          color: Color(0xFF2E7D32),
                          size: 20,
                        ),
                        10.horizontalSpace,
                        Text(
                          "Discount Applied: -\$${details.discount}",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                  ),
                20.verticalSpace,
                Text(
                  "Payment Summary",
                  style: TextStyle(
                    fontFamily: 'DM',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                12.verticalSpace,
                _row("Price", "\$${details.subTotal}"),
                if (details.tax != null && details.tax != "0") ...[
                  8.verticalSpace,
                  _row("Tax", "\$${details.tax}"),
                ],
                8.verticalSpace,
                _row("Total", "\$${details.total}", isTotal: true),
                20.verticalSpace,
                Row(
                  children: [
                    Icon(Icons.local_shipping_outlined, color: AppColors.mainColor),
                    10.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order Status",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          details.status,
                          style: TextStyle(
                            fontFamily: 'DM',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                24.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String l, String v, {bool isTotal = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        l,
        style: TextStyle(
          fontSize: isTotal ? 15.sp : 13.sp,
          fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          color: isTotal ? Colors.black87 : AppColors.darkGrayColor,
        ),
      ),
      Text(
        v,
        style: TextStyle(
          fontFamily: isTotal ? 'DM' : null,
          fontSize: isTotal ? 17.sp : 13.sp,
          fontWeight: FontWeight.bold,
          color: isTotal ? AppColors.darkColor : Colors.black87,
        ),
      ),
    ],
  );
}
