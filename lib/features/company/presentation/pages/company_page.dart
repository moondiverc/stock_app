import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_app/core/common/widgets/appbar.dart';
import 'package:stock_app/core/common/widgets/bottom_navbar.dart';
import 'package:stock_app/core/common/widgets/loader.dart';
import 'package:stock_app/core/theme/app_pallete.dart';
import 'package:stock_app/core/utils/url_launcher.dart';
import 'package:stock_app/features/company/presentation/cubit/company_cubit.dart';

class CompanyPage extends StatefulWidget {
  final String ticker;
  final String price;
  final String changePercentage;

  const CompanyPage({
    super.key,
    required this.ticker,
    required this.price,
    required this.changePercentage,
  });

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  @override
  void initState() {
    super.initState();
    context.read<CompanyCubit>().getCompanyData(widget.ticker);
  }

  String _formatMarketCap(String value) {
    try {
      double cap = double.parse(value);
      if (cap >= 1000000000000)
        return '${(cap / 1000000000000).toStringAsFixed(2)}T';
      if (cap >= 1000000000) return '${(cap / 1000000000).toStringAsFixed(2)}B';
      if (cap >= 1000000) return '${(cap / 1000000).toStringAsFixed(2)}M';
      return value;
    } catch (e) {
      return value == '-' ? '-' : value;
    }
  }

  String _formatDivYield(String value) {
    try {
      double yieldVal = double.parse(value);
      return '${(yieldVal * 100).toStringAsFixed(2)}%';
    } catch (e) {
      return value == '-' ? '-' : value;
    }
  }

  Widget _buildTrendChart(List<double> prices, bool isTrendUp) {
    if (prices.isEmpty) {
      return _buildStaircasePlaceholder(isTrendUp);
    }

    double minPrice = prices.reduce((a, b) => a < b ? a : b);
    double maxPrice = prices.reduce((a, b) => a > b ? a : b);
    double priceRange = maxPrice - minPrice;

    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(prices.length, (index) {
          double currentPrice = prices[index];
          bool isLast = index == prices.length - 1;

          double barHeight = priceRange == 0
              ? 70.0
              : ((currentPrice - minPrice) / priceRange) * 70.0 + 40.0;

          return Container(
            width: (MediaQuery.of(context).size.width - 100) / prices.length,
            height: barHeight,
            decoration: BoxDecoration(
              color: isLast
                  ? (isTrendUp ? const Color(0xFF5533BB) : Colors.red)
                  : const Color(0xFFE5E5EA),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStaircasePlaceholder(bool isTrendUp) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(8, (index) {
          bool isLast = index == 7;
          double barHeight = isTrendUp
              ? 50.0 + (index * 10)
              : 120.0 - (index * 10);
          return Container(
            width: 30,
            height: barHeight,
            decoration: BoxDecoration(
              color: isLast
                  ? (isTrendUp ? const Color(0xFF5533BB) : Colors.red)
                  : const Color(0xFFE5E5EA),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyCubit, CompanyState>(
      builder: (context, state) {
        String companyName = (state is CompanyLoaded)
            ? state.company.name
            : widget.ticker;

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          appBar: StockAppBar(title: widget.ticker, subtitle: companyName),
          bottomNavigationBar: const BottomNavbar(currentIndex: 0),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(CompanyState state) {
    if (state is CompanyLoading || state is CompanyInitial) {
      return const Loader();
    } else if (state is CompanyFailure) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            state.error,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppPallete.errorColor),
          ),
        ),
      );
    } else if (state is CompanyLoaded) {
      final company = state.company;
      final bool isPositive = widget.changePercentage.startsWith('+');

      return SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.price,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.changePercentage,
                    style: TextStyle(
                      color: isPositive
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildTrendChart(state.historicalPrices, state.isTrendUp),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    'Market Cap',
                    _formatMarketCap(company.marketCap),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: _buildInfoCard('P/E Ratio', company.peRatio)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    'Div Yield',
                    _formatDivYield(company.dividendYield),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: _buildInfoCard('Sector', company.sector)),
              ],
            ),
            const SizedBox(height: 32),

            const Text(
              'About',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              company.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            InkWell(
              onTap: () =>
                  UrlLauncherUtil.launchWebsite(context, company.website),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.language, color: AppPallete.themeColor, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Visit Website',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.themeColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black45,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
