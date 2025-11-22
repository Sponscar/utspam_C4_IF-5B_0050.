import 'dart:convert';

class TransaksiModel {
  final String id;
  final String obatId;
  final String namaObat;
  final int jumlah;
  final int totalHarga;
  final String tanggal;

  TransaksiModel({
    required this.id,
    required this.obatId,
    required this.namaObat,
    required this.jumlah,
    required this.totalHarga,
    required this.tanggal,
  });

  factory TransaksiModel.fromMap(Map<String, dynamic> map) {
    return TransaksiModel(
      id: map['id'],
      obatId: map['obatId'],
      namaObat: map['namaObat'],
      jumlah: map['jumlah'],
      totalHarga: map['totalHarga'],
      tanggal: map['tanggal'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'obatId': obatId,
      'namaObat': namaObat,
      'jumlah': jumlah,
      'totalHarga': totalHarga,
      'tanggal': tanggal,
    };
  }

  factory TransaksiModel.fromJson(String json) {
    return TransaksiModel.fromMap(jsonDecode(json));
  }

  String toJson() => jsonEncode(toMap());
}
