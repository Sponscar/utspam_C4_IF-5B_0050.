import 'dart:convert';

class TransaksiModel {
  final String idTransaksi;
  final String idObat;
  final String namaObat;
  final int jumlah;
  final int totalHarga;
  final String tanggal;

  TransaksiModel({
    required this.idTransaksi,
    required this.idObat,
    required this.namaObat,
    required this.jumlah,
    required this.totalHarga,
    required this.tanggal,
  });

  factory TransaksiModel.fromMap(Map<String, dynamic> map) {
    return TransaksiModel(
      idTransaksi: map['idTransaksi'] ?? '',
      idObat: map['idObat'] ?? '',
      namaObat: map['namaObat'] ?? '',
      jumlah: map['jumlah'] ?? 0,
      totalHarga: map['totalHarga'] ?? 0,
      tanggal: map['tanggal'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idTransaksi': idTransaksi,
      'idObat': idObat,
      'namaObat': namaObat,
      'jumlah': jumlah,
      'totalHarga': totalHarga,
      'tanggal': tanggal,
    };
  }

  factory TransaksiModel.fromJson(String json) {
    return TransaksiModel.fromMap(jsonDecode(json));
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
