import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_app/core/common/widgets/appbar.dart';
import 'package:stock_app/core/common/widgets/bottom_navbar.dart';
import 'package:stock_app/core/common/widgets/loader.dart';
import 'package:stock_app/core/theme/app_pallete.dart';
import 'package:stock_app/core/utils/url_launcher.dart';
import 'package:stock_app/features/company/domain/entities/company.dart';
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

  @override
  Widget build(BuildContext context) {
    String formatMarketCap(String value) {
      if (value == 'None' || value == '0' || value == '-') return 'N/A';
      try {
        double cap = double.parse(value);
        if (cap >= 1000000000000) {
          return '${(cap / 1000000000000).toStringAsFixed(2)}T';
        }
        if (cap >= 1000000000) {
          return '${(cap / 1000000000).toStringAsFixed(2)}B';
        }
        if (cap >= 1000000) {
          return '${(cap / 1000000).toStringAsFixed(2)}M';
        }
        return value;
      } catch (_) {
        return 'N/A';
      }
    }

    String formatDivYield(String value) {
      try {
        double yieldVal = double.parse(value);
        return '${(yieldVal * 100).toStringAsFixed(2)}%';
      } catch (_) {
        return value == 'None' || value == '-' ? '-' : value;
      }
    }

    return BlocBuilder<CompanyCubit, CompanyState>(
      builder: (context, state) {
        String companyName = (state is CompanyLoaded)
            ? state.company.name
            : widget.ticker;

        return Scaffold(
          backgroundColor: AppPallete.backgroundColor,
          appBar: StockAppBar(title: widget.ticker, subtitle: companyName),
          bottomNavigationBar: const BottomNavbar(currentIndex: 0),
          body: Builder(
            builder: (context) {
              if (state is CompanyLoading || state is CompanyInitial) {
                return const Loader();
              }

              if (state is CompanyFailure) {
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
              }

              if (state is CompanyLoaded) {
                final company = state.company;
                final bool isPositive = widget.changePercentage.startsWith('+');
                final prices = state.historicalPrices;
                final isTrendUp = state.isTrendUp;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPriceHeader(isPositive),
                      const SizedBox(height: 16),

                      _buildTrendChart(prices, isTrendUp),
                      const SizedBox(height: 24),

                      _buildInfoGrid(company, formatMarketCap, formatDivYield),
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

                      _buildWebsiteLink(company.website),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }

  Widget _buildPriceHeader(bool isPositive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '\$${widget.price}',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isPositive
                ? AppPallete.sentimentBullish
                : AppPallete.sentimentBearish,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.changePercentage,
            style: TextStyle(
              color: isPositive
                  ? AppPallete.sentimentBullishText
                  : AppPallete.sentimentBearishText,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendChart(List<double> prices, bool isTrendUp) {
    return Container(
      height: 140,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.backgroundTileColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.borderTileColor, width: 1),
      ),
      child: prices.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart_outlined, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'Historical chart data unavailable',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(prices.length, (index) {
                double minP = prices.reduce((a, b) => a < b ? a : b);
                double maxP = prices.reduce((a, b) => a > b ? a : b);
                double range = maxP - minP;
                double currentP = prices[index];

                Color barColor = (index == 0)
                    ? AppPallete.gainColor
                    : (currentP >= prices[index - 1]
                          ? AppPallete.gainColor
                          : AppPallete.lossColor);

                double barH = range == 0
                    ? 70.0
                    : ((currentP - minP) / range) * 70.0 + 40.0;

                return Container(
                  width:
                      (MediaQuery.of(context).size.width - 100) / prices.length,
                  height: barH,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
    );
  }

  Widget _buildInfoGrid(
    Company company,
    String Function(String) formatCap,
    String Function(String) formatYield,
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.1,
      children: [
        _buildTile('Market Cap', formatCap(company.marketCap)),
        _buildTile('P/E Ratio', company.peRatio),
        _buildTile('Div Yield', formatYield(company.dividendYield)),
        _buildTile('Sector', company.sector),
      ],
    );
  }

  Widget _buildTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.backgroundTileColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppPallete.borderTileColor, width: 1),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppPallete.blackColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppPallete.textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildWebsiteLink(String url) {
    return InkWell(
      onTap: () => UrlLauncherUtil.launchWebsite(context, url),
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
    );
  }
}
