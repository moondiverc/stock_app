import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_app/core/common/widgets/appbar.dart';
import 'package:stock_app/core/common/widgets/bottom_navbar.dart';
import 'package:stock_app/core/common/widgets/loader.dart';
import 'package:stock_app/core/utils/show_snackbar.dart';
import 'package:stock_app/features/news/presentation/cubit/news_cubit.dart';
import 'package:stock_app/features/news/presentation/pages/news_detail.dart';
import 'package:stock_app/features/news/presentation/widgets/news_card.dart';

class NewsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const NewsPage());

  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NewsCubit>().getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StockAppBar(
        title: 'Latest News',
        subtitle: 'Market Insights & updates',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<NewsCubit, NewsState>(
          listener: (context, state) {
            if (state is NewsFailure) {
              showSnackbar(context, state.error);
            }
          },
          builder: (context, state) {
            if (state is NewsLoading) {
              return const Loader();
            }

            if (state is NewsFailure) {
              return Center(child: Text(state.error));
            }

            if (state is NewsLoaded) {
              return ListView.builder(
                itemCount: state.news.length,
                itemBuilder: (context, index) {
                  final news = state.news[index];
                  return NewsCard(
                    news: news,
                    onTap: () {
                      Navigator.push(context, NewsDetailPage.route(news));
                    },
                  );
                },
              );
            }

            return const Center(child: Text('No News'));
          },
        ),
      ),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
