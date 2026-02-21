import 'package:flutter/material.dart';
import 'package:stock_app/core/common/widgets/appbar.dart';
import 'package:stock_app/core/common/widgets/bottom_navbar.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StockAppBar(
        title: 'Company',
        subtitle: 'International Business Machines',
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
