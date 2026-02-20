import 'package:flutter/material.dart';
import 'package:stock_app/core/common/widgets/appbar.dart';
import 'package:stock_app/core/common/widgets/bottom_navbar.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StockAppBar(
        title: 'Market Overview',
        subtitle: 'Today\'s top performers',
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
