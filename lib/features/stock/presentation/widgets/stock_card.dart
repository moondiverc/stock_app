import 'package:flutter/material.dart';
import 'package:stock_app/core/theme/app_pallete.dart';
import '../../domain/entities/stock.dart';

class StockCard extends StatelessWidget {
  final Stock stock;

  const StockCard({super.key, required this.stock});

  String _formatVolume(String volumeStr) {
    try {
      double vol = double.parse(volumeStr);
      if (vol >= 1000000) {
        return '${(vol / 1000000).toStringAsFixed(1)}M';
      } else if (vol >= 1000) {
        return '${(vol / 1000).toStringAsFixed(1)}K';
      }
      return vol.toStringAsFixed(0);
    } catch (e) {
      return volumeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNegative = stock.changePercentage.startsWith('-');

    final color = isNegative ? AppPallete.lossColor : AppPallete.gainColor;
    final icon = isNegative ? Icons.arrow_downward : Icons.arrow_upward;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stock.ticker,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Vol: ${_formatVolume(stock.volume)}',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${stock.price}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Icon(icon, color: color, size: 12.0),
                      const SizedBox(width: 2.0),
                      Text(
                        stock.changePercentage,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          height: 1.0,
          thickness: 1.0,
          color: Colors.grey.shade200,
          indent: 24.0,
          endIndent: 24.0,
        ),
      ],
    );
  }
}
