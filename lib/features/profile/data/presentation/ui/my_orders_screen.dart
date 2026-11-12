import 'package:app3/core/routes/app_route.dart';
import 'package:app3/core/themes/app_colors.dart';
import 'package:app3/features/profile/data/presentation/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../checkout/data/presentation/checkout_cubit.dart';
import '../../../../checkout/data/presentation/ui/checkout_screen.dart';
import 'order_details_screen.dart';
import 'widgets/order_card.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().getOrders();
    });
  }

  void _openCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CheckoutCubit()..load(),
          child: const CheckoutScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.r),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 16.sp,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "My Orders",
          style: TextStyle(
            fontFamily: 'DM',
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: _openCheckout,
            icon: Icon(
              Icons.shopping_cart_checkout,
              color: AppColors.mainColor,
              size: 20.sp,
            ),
            label: Text(
              "Checkout",
              style: TextStyle(
                color: AppColors.mainColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            tooltip: "Refresh Orders",
            icon: Icon(
              Icons.refresh_rounded,
              size: 22.sp,
              color: Colors.black87,
            ),
            onPressed: () {
              context.read<ProfileCubit>().getOrders();
            },
          ),
          8.horizontalSpace,
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is GetOrdersError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: const Color(0xFFE53935),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          buildWhen: (_, current) =>
          current is GetOrdersLoading ||
              current is GetOrdersSuccess ||
              current is GetOrdersError,
          builder: (context, state) {
            if (state is GetOrdersLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.mainColor,
                    ),
                    16.verticalSpace,
                    Text(
                      "Loading orders...",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.darkGrayColor,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is GetOrdersError) {
              return _buildErrorView(context, state.message);
            }

            if (state is GetOrdersSuccess) {
              final orders = state.orders;

              if (orders.isEmpty) {
                return _buildEmptyView(context);
              }

              return RefreshIndicator(
                color: AppColors.mainColor,
                onRefresh: () => context.read<ProfileCubit>().getOrders(),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => 12.verticalSpace,
                  itemBuilder: (context, i) {
                    final order = orders[i];

                    return OrderCard(
                      order: order,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<ProfileCubit>()
                                ..getOrderDetails(order.id),
                              child: const OrderDetailsScreen(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110.w,
              height: 110.w,
              decoration: BoxDecoration(
                color: AppColors.mainColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.receipt_long_outlined,
                  size: 52.sp,
                  color: AppColors.mainColor,
                ),
              ),
            ),
            20.verticalSpace,
            Text(
              "No Orders Yet",
              style: TextStyle(
                fontFamily: 'DM',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            8.verticalSpace,
            Text(
              "You haven't placed any orders so far.\nExplore our bookstore and order your next favorite book!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.darkGrayColor,
                height: 1.4,
              ),
            ),
            24.verticalSpace,
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.buttonNavBarScreen,
                      (route) => false,
                );
              },
              icon: Icon(
                Icons.shopping_bag_outlined,
                size: 18.sp,
                color: Colors.white,
              ),
              label: Text(
                "Explore Books",
                style: TextStyle(
                  fontFamily: 'DM',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    final isAuthError = message.toLowerCase().contains("login") ||
        message.toLowerCase().contains("unauthenticated") ||
        message.toLowerCase().contains("session");

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  isAuthError
                      ? Icons.lock_outline_rounded
                      : Icons.error_outline_rounded,
                  size: 48.sp,
                  color: const Color(0xFFE53935),
                ),
              ),
            ),
            20.verticalSpace,
            Text(
              isAuthError
                  ? "Authentication Required"
                  : "Failed to Load Orders",
              style: TextStyle(
                fontFamily: 'DM',
                fontSize: 19.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            10.verticalSpace,
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.darkGrayColor,
                height: 1.4,
              ),
            ),
            24.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<ProfileCubit>().getOrders();
                  },
                  icon: Icon(
                    Icons.refresh_rounded,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Try Again",
                    style: TextStyle(
                      fontFamily: 'DM',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 0,
                  ),
                ),
                if (isAuthError) ...[
                  12.horizontalSpace,
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.loginScreen,
                            (route) => false,
                      );
                    },
                    icon: Icon(
                      Icons.login_rounded,
                      size: 18.sp,
                      color: AppColors.mainColor,
                    ),
                    label: Text(
                      "Log In",
                      style: TextStyle(
                        fontFamily: 'DM',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mainColor,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppColors.mainColor,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}