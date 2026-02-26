import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_app/core/theme/theme.dart';
import 'package:stock_app/features/company/presentation/cubit/company_cubit.dart';
import 'package:stock_app/features/news/presentation/cubit/news_cubit.dart';
import 'package:stock_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:stock_app/features/stock/presentation/cubit/stock_cubit.dart';
import 'package:stock_app/features/stock/presentation/pages/stock_page.dart';
import 'package:stock_app/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // binding init
  await initDependencies(); // dependencies init
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<NewsCubit>()),
        BlocProvider(create: (_) => serviceLocator<StockCubit>()),
        BlocProvider(create: (_) => serviceLocator<CompanyCubit>()),
        BlocProvider(create: (_) => serviceLocator<ProfileCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock App',
      theme: AppTheme.lightThemeMode,
      home: StockPage(),
    );
  }
}
