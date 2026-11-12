import 'package:app3/bookia_App.dart';
import 'package:app3/core/networking/dio_factory.dart';
import 'package:app3/core/services/local/local_Helper.dart';
import 'package:app3/features/products/data/repo/product_repo.dart';
import 'package:app3/features/products/presention/product_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await localHelper.init();

  DioFactory.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: BlocProvider(
        create: (context) => ProductCubit(ProductRepo())..getProduct(),
        child: BookiaApp(),
      ),
    ),
  );
}