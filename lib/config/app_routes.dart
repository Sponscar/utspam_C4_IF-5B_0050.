import 'package:aplikasi_apotek/pages/pembelian/daftar_obat_page.dart';
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
  static const daftarObat = '/daftar-obat';
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
        return MaterialPageRoute(
          builder: (_) => FormPembelianPage(),
          settings: settings,
        );

      case AppRoutes.daftarObat:
        return MaterialPageRoute(builder: (_) => const DaftarObatPage());

      case AppRoutes.riwayat:
        return MaterialPageRoute(builder: (_) => RiwayatPage());

      case AppRoutes.detail:
        return MaterialPageRoute(
          builder: (_) => const DetailPage(),
          settings: settings,
      );

      case AppRoutes.editTransaksi:
        return MaterialPageRoute(
          builder: (_) => const EditTransaksiPage(),
          settings: settings,
        );

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }
}

