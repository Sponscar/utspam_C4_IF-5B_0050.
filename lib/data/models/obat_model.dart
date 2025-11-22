import 'dart:convert';

class ObatModel {
  final String id;
  final String nama;
  final int harga;
  final int stok;
  final String deskripsi;

  ObatModel({
    required this.id,
    required this.nama,
    required this.harga,
    required this.stok,
    this.deskripsi = "",
  });

  // Konversi MAP → ObatModel
  factory ObatModel.fromMap(Map<String, dynamic> map) {
    return ObatModel(
      id: map['id'] ?? '',
      nama: map['nama'] ?? '',
      harga: map['harga'] ?? 0,
      stok: map['stok'] ?? 0,
      deskripsi: map['deskripsi'] ?? '',
    );
  }

  // Konversi ObatModel → MAP
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'harga': harga,
      'stok': stok,
      'deskripsi': deskripsi,
    };
  }

  // JSON → ObatModel
  factory ObatModel.fromJson(String json) {
    return ObatModel.fromMap(jsonDecode(json));
  }

  // ObatModel → JSON
  String toJson() {
    return jsonEncode(toMap());
  }
}
