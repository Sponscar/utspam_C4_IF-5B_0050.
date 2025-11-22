import 'package:flutter/material.dart';

// Import semua halaman
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/home/home_page.dart';
import '../pages/pembelian/form_pembelian_page.dart';
import '../pages/pembelian/riwayat_page.dart';
import '../pages/pembelian/detail_page.dart';
import '../pages/pembelian/edit_transaksi_page.dart';
import '../pages/user/profile_page.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const pembelian = '/pembelian';
  static const riwayat = '/riwayat';
  static const detail = '/detail';
  static const editTransaksi = '/edit-transaksi';
  static const profile = '/profile';
}

class AppRouteGenerator {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case AppRoutes.pembelian:
        return MaterialPageRoute(builder: (_) => const FormPembelianPage());

      case AppRoutes.riwayat:
        return MaterialPageRoute(builder: (_) => const RiwayatPage());

      case AppRoutes.detail:
        return MaterialPageRoute(builder: (_) => const DetailPage());

      case AppRoutes.editTransaksi:
        return MaterialPageRoute(builder: (_) => const EditTransaksiPage());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text("404 - Page Not Found"),
            ),
          ),
        );
    }
  }
}
