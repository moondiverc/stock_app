import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_app/core/common/widgets/appbar.dart';
import 'package:stock_app/core/common/widgets/bottom_navbar.dart';
import 'package:stock_app/core/theme/app_pallete.dart';
import 'package:stock_app/features/company/presentation/cubit/company_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _launchWebsite(String urlString) async {
    if (urlString.isEmpty || urlString == '-') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Website url is not available')),
        );
      }
      return;
    }

    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the website')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyCubit, CompanyState>(
      builder: (context, state) {
        String companyName = 'Loading...';

        if (state is CompanyLoaded) {
          companyName = state.company.name;
        } else if (state is CompanyFailure) {
          companyName = 'Failed to load data';
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          appBar: StockAppBar(title: widget.ticker, subtitle: companyName),
          bottomNavigationBar: const BottomNavbar(),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(CompanyState state) {
    if (state is CompanyLoading || state is CompanyInitial) {
      return const Center(
        child: CircularProgressIndicator(color: AppPallete.themeColor),
      );
    } else if (state is CompanyFailure) {
      return Center(
        child: Text(
          state.error,
          style: const TextStyle(color: AppPallete.errorColor),
        ),
      );
    } else if (state is CompanyLoaded) {
      final company = state.company;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                children: List.generate(8, (index) {
                  bool isLast = index == 7;
                  return Container(
                    width: 30,
                    height: 50.0 + (index * 10),
                    decoration: BoxDecoration(
                      color: isLast
                          ? AppPallete.themeColor
                          : const Color(0xFFE5E5EA),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
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
            const SizedBox(height: 16),

            InkWell(
              onTap: () {
                _launchWebsite(company.website);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.language,
                    color: AppPallete.themeColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
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
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
