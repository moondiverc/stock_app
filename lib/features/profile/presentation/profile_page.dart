import 'package:flutter/material.dart';
import 'package:stock_app/core/common/widgets/appbar.dart';
import 'package:stock_app/core/common/widgets/bottom_navbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: StockAppBar(
        title: 'Nezzaluna Azzahra',
        subtitle: 'Computer Science 2024',
      ),
      bottomNavigationBar: BottomNavbar(currentIndex: 2),
      backgroundColor: Color(0xFFF9F9F9),
    );
  }
}
