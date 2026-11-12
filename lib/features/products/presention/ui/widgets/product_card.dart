import 'package:app3/core/themes/app_colors.dart';
import 'package:app3/features/products/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.discountPercentage != null &&
        product.discountPercentage! > 0;
    final originalPrice = hasDiscount
        ? (product.price / (1 - (product.discountPercentage! / 100)))
        : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
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
            // Thumbnail with badges
            Expanded(
              flex: 11,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(14.r),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: AppColors.bgColor,
                      child: product.thumbnail != null &&
                              product.thumbnail!.isNotEmpty
                          ? Image.network(
                              product.thumbnail!,
                              fit: BoxFit.contain,
                              errorBuilder: (ctx, err, stack) => Center(
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  size: 36.sp,
                                  color: AppColors.grayColor,
                                ),
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.inventory_2_outlined,
                                size: 36.sp,
                                color: AppColors.grayColor,
                              ),
                            ),
                    ),
                  ),

                  // Discount Badge
                  if (hasDiscount)
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          "-${product.discountPercentage!.toStringAsFixed(0)}%",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Rating Badge
                  if (product.rating != null)
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 13.sp,
                              color: const Color(0xFFFFA000),
                            ),
                            2.horizontalSpace,
                            Text(
                              product.rating!.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Product Details
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
                        // Category / Brand
                        Text(
                          (product.brand ?? product.category).toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            color: AppColors.mainColor,
                          ),
                        ),
                        3.verticalSpace,

                        // Title
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'DM',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),

                    // Price & Action Button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (hasDiscount && originalPrice != null)
                                Text(
                                  "\$${originalPrice.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    decoration: TextDecoration.lineThrough,
                                    color: AppColors.grayColor,
                                  ),
                                ),
                              Text(
                                "\$${product.price.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontFamily: 'DM',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            onTap();
                          },
                          borderRadius: BorderRadius.circular(20.r),
                          child: Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 14.sp,
                              color: Colors.white,
                            ),
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
      ),
    );
  }
}
