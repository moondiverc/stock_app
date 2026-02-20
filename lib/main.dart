import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_app/features/news/presentation/cubit/news_cubit.dart';
import 'package:stock_app/features/news/presentation/pages/news_page.dart';
import 'package:stock_app/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<NewsCubit>()),
      ],
      child: MaterialApp(
        title: 'Stock App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const NewsPage(),
      ),
    );
  }
}
