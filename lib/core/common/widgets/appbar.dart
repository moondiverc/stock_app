import 'package:flutter/material.dart';
import 'package:stock_app/core/theme/app_palLete.dart';

class StockAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;

  const StockAppBar({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Padding bawah agar teks tidak terlalu mepet dengan lengkungan
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
      decoration: const BoxDecoration(
        color: AppPallete.themeColor, // Menggunakan warna utama dari AppPalette
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
        ),
      ),
      // SafeArea agar teks tidak tertutup status bar / notch HP
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Agar tinggi column menyesuaikan isi
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppPallete
                    .whiteColor, // Menggunakan warna putih dari AppPalette
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              subtitle,
              style: TextStyle(
                // Menggunakan withOpacity agar warna putihnya sedikit transparan seperti di desain
                color: AppPallete.whiteColor.withOpacity(0.8),
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menentukan tinggi AppBar. 110.0 biasanya cukup untuk menampung title + subtitle + safearea
  @override
  Size get preferredSize => const Size.fromHeight(110.0);
}
