import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaksi_model.dart';

class LocalTransaksi {
  static const String transaksiKey = 'transaksi_data';

  /// AMBIL SEMUA TRANSAKSI
  static Future<List<TransaksiModel>> getTransaksiList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(transaksiKey);

    if (jsonString == null) return [];

    List decoded = jsonDecode(jsonString);

    return decoded
        .map((map) => TransaksiModel.fromMap(map))
        .toList();
  }

  /// SIMPAN LIST TRANSAKSI
  static Future<void> _saveTransaksiList(List<TransaksiModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final listMap = list.map((t) => t.toMap()).toList();

    prefs.setString(transaksiKey, jsonEncode(listMap));
  }

  /// TAMBAH TRANSAKSI BARU
  static Future<void> tambahTransaksi(TransaksiModel transaksi) async {
    List<TransaksiModel> list = await getTransaksiList();
    list.add(transaksi);

    await _saveTransaksiList(list);
  }

  /// EDIT TRANSAKSI
  static Future<void> editTransaksi(TransaksiModel updatedTransaksi) async {
    List<TransaksiModel> list = await getTransaksiList();

    final index =
        list.indexWhere((t) => t.idTransaksi == updatedTransaksi.idTransaksi);

    if (index != -1) {
      list[index] = updatedTransaksi;
      await _saveTransaksiList(list);
    }
  }

  /// HAPUS TRANSAKSI
  static Future<void> hapusTransaksi(String idTransaksi) async {
    List<TransaksiModel> list = await getTransaksiList();

    list.removeWhere((t) => t.idTransaksi == idTransaksi);

    await _saveTransaksiList(list);
  }

  /// HAPUS SEMUA TRANSAKSI (opsional)
  static Future<void> clearTransaksi() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(transaksiKey);
  }
}