import 'package:app3/core/routes/app_route.dart';
import 'package:app3/features/book_details/presentaion/cubit/book_details_cubit.dart';
import 'package:app3/features/book_details/presentaion/ui/book_details_screen.dart';
import 'package:app3/features/button_nav_bar/presentation/ui/button_nav_bar_screen.dart';
import 'package:app3/features/presentaion/cubit/auth_cubit.dart';
import 'package:app3/features/presentaion/cubit/cubit/home_cubit.dart';
import 'package:app3/features/presentaion/ui/login_Screen.dart';
import 'package:app3/features/products/presention/ui/products_screen.dart';
import 'package:app3/features/profile/data/presentation/profile_cubit.dart';
import 'package:app3/features/profile/data/presentation/ui/my_orders_screen.dart';
import 'package:app3/features/welcome/presentaion/home/search_screen.dart';
import 'package:app3/features/welcome/presentaion/ui/register_screen.dart';
import 'package:app3/features/welcome/presentaion/ui/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route? onGenerateRoute(RouteSettings setting) {
    switch (setting.name) {
      case AppRoutes.loginScreen:
        return MaterialPageRoute(
          settings: setting,
          builder:
              (_) => BlocProvider(
                create: (context) => AuthCubit(),
                child: loginScreen(),
              ),
        );

      // Button Nav Bar Screen
      case AppRoutes.buttonNavBarScreen:
        return MaterialPageRoute(
          settings: setting,
          builder: (_) => const ButtonNavBarScreen(),
        );

      case AppRoutes.homeScreen:
        return MaterialPageRoute(
          settings: setting,
          builder: (_) => const ButtonNavBarScreen(),
        );

      case AppRoutes.welcomeScreen:
        return MaterialPageRoute(
          settings: setting,
          builder: (_) => const WelcomeScreen(),
        );

      case AppRoutes.registerScreen:
        return MaterialPageRoute(
          settings: setting,
          builder: (_) => const RegisterScreen(),
        );

      case AppRoutes.searchScreen:
        return MaterialPageRoute(
          settings: setting,
          builder:
              (_) => BlocProvider(
                create: (context) => HomeCubit(),
                child: SearchScreen(),
              ),
        );

      case AppRoutes.bookDetailsScreen:
        int id = setting.arguments as int;

        return MaterialPageRoute(
          settings: setting,
          builder:
              (_) => BlocProvider(
                create: (context) => BookDetailsCubit()..getDetails(id),
                child: BookDetailsScreen(bookId: id),
              ),
        );

      case AppRoutes.myOrdersScreen:
        return MaterialPageRoute(
          settings: setting,
          builder:
              (_) => BlocProvider(
                create: (context) => ProfileCubit()..getOrders(),
                child: const MyOrdersScreen(),
              ),
        );

      case AppRoutes.productsScreen:
        return MaterialPageRoute(
          settings: setting,
          builder: (_) => const ProductsScreen(),
        );

      default:
        return null;
    }
  }
}
