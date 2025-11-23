import 'package:flutter/material.dart';
import 'package:aplikasi_apotek/config/app_routes.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 WAJIB: Initialize locale Indonesia
  await initializeDateFormatting('id_ID', null);
  Intl.defaultLocale = 'id_ID';

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Apotek',

      // 🔥 Pusat Navigasi Aplikasi
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRouteGenerator.generate,

      // Tema optional
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
