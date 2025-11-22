import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaksi_model.dart';

class LocalTransaksi {
  static const String keyTransaksi = "list_transaksi";

  /// Simpan transaksi baru
  static Future<void> addTransaksi(TransaksiModel transaksi) async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil list lama
    final data = prefs.getStringList(keyTransaksi) ?? [];

    // Tambahkan transaksi baru (dalam bentuk JSON)
    data.add(transaksi.toJson());

    await prefs.setStringList(keyTransaksi, data);
  }

  /// Ambil semua transaksi
  static Future<List<TransaksiModel>> getTransaksi() async {
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList(keyTransaksi) ?? [];

    return list.map((e) => TransaksiModel.fromJson(e)).toList();
  }

  /// Hapus transaksi berdasarkan id
  static Future<void> deleteTransaksi(String id) async {
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList(keyTransaksi) ?? [];

    final newList = list.where((item) {
      final transaksi = TransaksiModel.fromJson(item);
      return transaksi.id != id;
    }).toList();

    await prefs.setStringList(keyTransaksi, newList);
  }

  /// Update transaksi berdasarkan id
  static Future<void> updateTransaksi(TransaksiModel newData) async {
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList(keyTransaksi) ?? [];

    final updatedList = list.map((item) {
      final transaksi = TransaksiModel.fromJson(item);
      return transaksi.id == newData.id ? newData.toJson() : item;
    }).toList();

    await prefs.setStringList(keyTransaksi, updatedList);
  }

  /// Hapus semua transaksi (opsional)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyTransaksi);
  }
}
