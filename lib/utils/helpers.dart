import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  /// ============================
  /// FORMAT HARGA (Rp 12.000)
  /// ============================
  static String formatRupiah(int value) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  /// ============================
  /// FORMAT TANGGAL (17 Nov 2025)
  /// ============================
  static String formatTanggal(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  /// ============================
  /// GENERATE ID TRANSAKSI UNIK
  /// ============================
  static String generateIdTransaksi() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return "TRX$timestamp"; // Contoh: TRX167293847234
  }

  /// ============================
  /// TAMPILKAN SNACKBAR
  /// ============================
  static showSnackbar(BuildContext context, String message,
      {Color color = Colors.blue}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
