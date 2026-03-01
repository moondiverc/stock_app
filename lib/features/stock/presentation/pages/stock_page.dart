import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_app/core/common/widgets/stock_appbar.dart';
import 'package:stock_app/core/common/widgets/bottom_navbar.dart';
import 'package:stock_app/core/common/widgets/loader.dart';
import 'package:stock_app/core/theme/app_pallete.dart';
import 'package:stock_app/features/company/presentation/pages/company_page.dart';
import 'package:stock_app/features/stock/presentation/cubit/stock_cubit.dart';
import 'package:stock_app/features/stock/presentation/widgets/stock_card.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  @override
  void initState() {
    super.initState();
    context.read<StockCubit>().getStocks();
  }

  Widget _buildListView(List stocks) {
    if (stocks.isEmpty) {
      return const Center(
        child: Text(
          'No data available.',
          style: TextStyle(color: AppPallete.greyColor),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        return StockCard(
          stock: stocks[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompanyPage(
                  ticker: stocks[index].ticker,
                  price: stocks[index].price,
                  changePercentage: stocks[index].changePercentage,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppPallete.backgroundColor,
        appBar: const StockAppBar(
          title: 'Market Overview',
          subtitle: 'Today\'s top performers',
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 20.0,
                left: 24.0,
                right: 24.0,
                bottom: 8.0,
              ),
              height: 44.0,
              decoration: BoxDecoration(
                color: AppPallete.tabColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: AppPallete.transparentColor,
                  indicator: BoxDecoration(
                    color: AppPallete.whiteColor,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: AppPallete.themeColor,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                  unselectedLabelColor: AppPallete.greyColor,
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                  tabs: const [
                    Tab(text: 'Gainers'),
                    Tab(text: 'Losers'),
                    Tab(text: 'Active'),
                  ],
                ),
              ),
            ),

            // tab views
            Expanded(
              child: BlocBuilder<StockCubit, StockState>(
                builder: (context, state) {
                  if (state is StockLoading) {
                    return const Loader();
                  } else if (state is StockFailure) {
                    return Center(
                      child: Text(
                        state.error,
                        style: const TextStyle(color: AppPallete.errorColor),
                      ),
                    );
                  } else if (state is StockLoaded) {
                    // tab views
                    return TabBarView(
                      children: [
                        _buildListView(state.gainers),
                        _buildListView(state.losers),
                        _buildListView(state.actives),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavbar(currentIndex: 0),
      ),
    );
  }
}
