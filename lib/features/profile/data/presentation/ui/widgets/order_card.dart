import 'package:app3/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../model/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  Color _getStatusColor(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('deliver') || lower.contains('complete') || lower.contains('success')) {
      return const Color(0xFF2E7D32);
    } else if (lower.contains('cancel') || lower.contains('reject') || lower.contains('fail')) {
      return const Color(0xFFD32F2F);
    } else {
      return AppColors.mainColor;
    }
  }

  Color _getStatusBg(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('deliver') || lower.contains('complete') || lower.contains('success')) {
      return const Color(0xFFE8F5E9);
    } else if (lower.contains('cancel') || lower.contains('reject') || lower.contains('fail')) {
      return const Color(0xFFFFEBEE);
    } else {
      return AppColors.mainColor.withValues(alpha: 0.12);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(order.status);
    final statusBg = _getStatusBg(order.status);
    final code = order.orderCode.trim();
    final displayCode = code.startsWith('#') ? code : '#$code';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Order Code and Date
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.bgColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.receipt_outlined,
                    size: 18.sp,
                    color: AppColors.darkColor,
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order $displayCode",
                        style: TextStyle(
                          fontFamily: 'DM',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (order.orderDate.isNotEmpty) ...[
                        3.verticalSpace,
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 12.sp,
                              color: AppColors.grayColor,
                            ),
                            4.horizontalSpace,
                            Text(
                              order.orderDate,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.grayColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.sp,
                  color: AppColors.grayColor,
                ),
              ],
            ),
            12.verticalSpace,
            Divider(color: AppColors.borderColor, height: 1),
            12.verticalSpace,

            // Bottom row: Status Chip and Total Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    order.status.isNotEmpty ? order.status : "Pending",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),

                // Total
                Text.rich(
                  TextSpan(
                    text: "Total: ",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.darkGrayColor,
                    ),
                    children: [
                      TextSpan(
                        text: "\$${order.total}",
                        style: TextStyle(
                          fontFamily: 'DM',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
