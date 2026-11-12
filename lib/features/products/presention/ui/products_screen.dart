import 'package:app3/core/themes/app_colors.dart';
import 'package:app3/features/products/data/model/product_model.dart';
import 'package:app3/features/products/presention/product_cubit.dart';
import 'package:app3/features/products/presention/ui/widgets/product_card.dart';
import 'package:app3/features/products/presention/ui/widgets/product_details_sheet.dart';
import 'package:app3/features/products/presention/ui/widgets/product_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      context.read<ProductCubit>();
      return const _ProductsScreenContent();
    } catch (_) {
      return BlocProvider(
        create: (_) => ProductCubit()..getProduct(),
        child: const _ProductsScreenContent(),
      );
    }
  }
}

class _ProductsScreenContent extends StatefulWidget {
  const _ProductsScreenContent();

  @override
  State<_ProductsScreenContent> createState() => _ProductsScreenContentState();
}

class _ProductsScreenContentState extends State<_ProductsScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<ProductCubit>();
      if (cubit.state is ProductInitial) {
        cubit.getProduct();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> _filterProducts(List<Product> allProducts) {
    final query = _searchController.text.trim().toLowerCase();

    return allProducts.where((product) {
      final matchesCategory = _selectedCategory == "All" ||
          product.category.toLowerCase() == _selectedCategory.toLowerCase();

      final matchesQuery = query.isEmpty ||
          product.title.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          (product.brand?.toLowerCase().contains(query) ?? false);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  List<String> _extractCategories(List<Product> allProducts) {
    final categories = <String>{"All"};
    for (final p in allProducts) {
      if (p.category.isNotEmpty) {
        categories.add(p.category);
      }
    }
    return categories.toList();
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: canPop
            ? Padding(
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
              )
            : null,
        centerTitle: false,
        title: Text(
          "Explore Products",
          style: TextStyle(
            fontFamily: 'DM',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductSuccess) {
                return Center(
                  child: Container(
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.mainColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppColors.mainColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      "${state.products.length} Items",
                      style: TextStyle(
                        fontFamily: 'DM',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkColor,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            tooltip: "Refresh",
            icon: Icon(
              Icons.refresh_rounded,
              size: 22.sp,
              color: Colors.black87,
            ),
            onPressed: () {
              context.read<ProductCubit>().getProduct();
            },
          ),
          8.horizontalSpace,
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<ProductCubit, ProductState>(
          listener: (context, state) {
            if (state is ProductError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: const Color(0xFFE53935),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProductLoading || state is ProductInitial) {
              return const ProductSkeletonLoading();
            }

            if (state is ProductError) {
              return _buildErrorView(context, state.error);
            }

            if (state is ProductSuccess) {
              final allProducts = state.products;
              final categories = _extractCategories(allProducts);
              final filteredProducts = _filterProducts(allProducts);

              return Column(
                children: [
                  10.verticalSpace,

                  // Search Bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Container(
                      height: 46.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        style: TextStyle(fontSize: 14.sp),
                        decoration: InputDecoration(
                          hintText: "Search products, brands, categories...",
                          hintStyle: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.grayColor,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            size: 20.sp,
                            color: AppColors.grayColor,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.close_rounded,
                                    size: 18.sp,
                                    color: AppColors.grayColor,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),
                  ),
                  12.verticalSpace,

                  // Categories Filter Chips
                  SizedBox(
                    height: 36.h,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => 8.horizontalSpace,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = category.toLowerCase() ==
                            _selectedCategory.toLowerCase();

                        return ChoiceChip(
                          label: Text(
                            category.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.darkGrayColor,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            }
                          },
                          selectedColor: AppColors.mainColor,
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.mainColor
                                : AppColors.borderColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          showCheckmark: false,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                        );
                      },
                    ),
                  ),
                  12.verticalSpace,

                  // Grid of Products or Empty search results
                  Expanded(
                    child: filteredProducts.isEmpty
                        ? _buildEmptyResultsView()
                        : RefreshIndicator(
                            color: AppColors.mainColor,
                            onRefresh: () =>
                                context.read<ProductCubit>().getProduct(),
                            child: GridView.builder(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 6.h,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.62,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 14.h,
                              ),
                              itemCount: filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = filteredProducts[index];
                                return ProductCard(
                                  product: product,
                                  onTap: () {
                                    ProductDetailsSheet.show(context, product);
                                  },
                                );
                              },
                            ),
                          ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyResultsView() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90.w,
              height: 90.w,
              decoration: BoxDecoration(
                color: AppColors.mainColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.search_off_rounded,
                  size: 42.sp,
                  color: AppColors.mainColor,
                ),
              ),
            ),
            18.verticalSpace,
            Text(
              "No Products Found",
              style: TextStyle(
                fontFamily: 'DM',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            6.verticalSpace,
            Text(
              "We couldn't find any products matching your filters.\nTry searching with different keywords.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.darkGrayColor,
                height: 1.4,
              ),
            ),
            18.verticalSpace,
            ElevatedButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _selectedCategory = "All";
                });
              },
              icon: Icon(
                Icons.filter_alt_off_rounded,
                size: 16.sp,
                color: Colors.white,
              ),
              label: Text(
                "Reset Filters",
                style: TextStyle(
                  fontFamily: 'DM',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 10.h,
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

  Widget _buildErrorView(BuildContext context, String error) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90.w,
              height: 90.w,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.cloud_off_rounded,
                  size: 44.sp,
                  color: const Color(0xFFE53935),
                ),
              ),
            ),
            18.verticalSpace,
            Text(
              "Failed to Load Products",
              style: TextStyle(
                fontFamily: 'DM',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            8.verticalSpace,
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.darkGrayColor,
                height: 1.4,
              ),
            ),
            20.verticalSpace,
            ElevatedButton.icon(
              onPressed: () {
                context.read<ProductCubit>().getProduct();
              },
              icon: Icon(
                Icons.refresh_rounded,
                size: 16.sp,
                color: Colors.white,
              ),
              label: Text(
                "Try Again",
                style: TextStyle(
                  fontFamily: 'DM',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 11.h,
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
}
