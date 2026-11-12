import 'package:app3/core/themes/app_colors.dart';
import 'package:app3/core/widget/App_button.dart';
import 'package:app3/features/products/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsSheet extends StatelessWidget {
  final Product product;

  const ProductDetailsSheet({super.key, required this.product});

  static void show(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProductDetailsSheet(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.discountPercentage != null &&
        product.discountPercentage! > 0;
    final originalPrice = hasDiscount
        ? (product.price / (1 - (product.discountPercentage! / 100)))
        : null;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          16.verticalSpace,

          // Scrollable body
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Center(
                    child: Container(
                      height: 220.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.bgColor,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: product.thumbnail != null &&
                                product.thumbnail!.isNotEmpty
                            ? Image.network(
                                product.thumbnail!,
                                fit: BoxFit.contain,
                                errorBuilder: (ctx, err, stack) => Center(
                                  child: Icon(
                                    Icons.inventory_2_outlined,
                                    size: 64.sp,
                                    color: AppColors.grayColor,
                                  ),
                                ),
                              )
                            : Center(
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  size: 64.sp,
                                  color: AppColors.grayColor,
                                ),
                              ),
                      ),
                    ),
                  ),
                  18.verticalSpace,

                  // Tags Row
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: [
                      // Category
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          product.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkColor,
                          ),
                        ),
                      ),

                      // Brand
                      if (product.brand != null && product.brand!.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.bgColor,
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(color: AppColors.borderColor),
                          ),
                          child: Text(
                            product.brand!,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGrayColor,
                            ),
                          ),
                        ),

                      // Rating
                      if (product.rating != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E1),
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(color: const Color(0xFFFFE082)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 14.sp,
                                color: const Color(0xFFFFA000),
                              ),
                              3.horizontalSpace,
                              Text(
                                "${product.rating} / 5",
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFF57F17),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Stock
                      if (product.stock != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: (product.stock ?? 0) > 5
                                ? const Color(0xFFE8F5E9)
                                : const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            (product.stock ?? 0) > 0
                                ? "In Stock (${product.stock})"
                                : "Out of Stock",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: (product.stock ?? 0) > 5
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFC62828),
                            ),
                          ),
                        ),
                    ],
                  ),
                  14.verticalSpace,

                  // Title
                  Text(
                    product.title,
                    style: TextStyle(
                      fontFamily: 'DM',
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.25,
                    ),
                  ),
                  12.verticalSpace,

                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "\$${product.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontFamily: 'DM',
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkColor,
                        ),
                      ),
                      if (hasDiscount && originalPrice != null) ...[
                        10.horizontalSpace,
                        Text(
                          "\$${originalPrice.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.grayColor,
                          ),
                        ),
                        8.horizontalSpace,
                        Container(
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
                      ],
                    ],
                  ),
                  16.verticalSpace,
                  Divider(color: AppColors.borderColor),
                  12.verticalSpace,

                  // Description
                  Text(
                    "Description",
                    style: TextStyle(
                      fontFamily: 'DM',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.darkGrayColor,
                      height: 1.5,
                    ),
                  ),
                  20.verticalSpace,
                ],
              ),
            ),
          ),
          12.verticalSpace,

          // Action Button
          AppButton(
            titel: "Close",
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
