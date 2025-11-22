import 'dart:convert';

class ObatModel {
  final String id;
  final String nama;
  final String kategori;
  final String gambar;  // path asset
  final int harga;

  ObatModel({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.gambar,
    required this.harga,
  });

  // MAP → ObatModel
  factory ObatModel.fromMap(Map<String, dynamic> map) {
    return ObatModel(
      id: map['id'] ?? '',
      nama: map['nama'] ?? '',
      kategori: map['kategori'] ?? '',
      gambar: map['gambar'] ?? '',
      harga: map['harga'] ?? 0,
    );
  }

  // ObatModel → MAP
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'kategori': kategori,
      'gambar': gambar,
      'harga': harga,
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
