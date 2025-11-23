import 'dart:convert';

class TransaksiModel {
  final String idTransaksi;
  final String idObat;
  final String namaObat;
  final String namaPembeli;
  final int jumlah;
  final int hargaSatuan;
  final int totalHarga;
  final String tanggal;
  final String metodePembelian;
  final String? nomorResep;
  final String status; // selesai / dibatalkan
  final String? catatan;

  TransaksiModel({
    required this.idTransaksi,
    required this.idObat,
    required this.namaObat,
    required this.namaPembeli,
    required this.jumlah,
    required this.hargaSatuan,
    required this.totalHarga,
    required this.tanggal,
    required this.metodePembelian,
    this.nomorResep,
    required this.status,
    this.catatan,
  });

  factory TransaksiModel.fromMap(Map<String, dynamic> map) {
    return TransaksiModel(
      idTransaksi: map['idTransaksi'] ?? '',
      idObat: map['idObat'] ?? '',
      namaObat: map['namaObat'] ?? '',
      namaPembeli: map['namaPembeli'] ?? '',
      jumlah: map['jumlah'] ?? 0,
      hargaSatuan: map['hargaSatuan'] ?? 0,
      totalHarga: map['totalHarga'] ?? 0,
      tanggal: map['tanggal'] ?? '',
      metodePembelian: map['metodePembelian'] ?? 'langsung',
      nomorResep: map['nomorResep'],
      status: map['status'] ?? 'selesai',
      catatan: map['catatan'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idTransaksi': idTransaksi,
      'idObat': idObat,
      'namaObat': namaObat,
      'namaPembeli': namaPembeli,
      'jumlah': jumlah,
      'hargaSatuan': hargaSatuan,
      'totalHarga': totalHarga,
      'tanggal': tanggal,
      'metodePembelian': metodePembelian,
      'nomorResep': nomorResep,
      'status': status,
      'catatan': catatan,
    };
  }

  factory TransaksiModel.fromJson(String json) {
    return TransaksiModel.fromMap(jsonDecode(json));
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
