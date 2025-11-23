import 'package:flutter/material.dart';
import '../../../data/datasource/local_transaksi.dart';
import '../../../data/models/transaksi_model.dart';
import '../../../utils/helpers.dart';
import '../../../config/app_routes.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<TransaksiModel> list = [];

  @override
  void initState() {
    super.initState();
    _loadTransaksi();
  }

  Future<void> _loadTransaksi() async {
    final data = await LocalTransaksi.getTransaksiList();
    setState(() => list = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Pembelian"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue.shade700,

        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              _showDeleteConfirmDialog();
            },
          ),
        ],
      ),

      body: list.isEmpty
          ? const Center(
              child: Text(
                "Riwayat pembelian masih kosong",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final t = list[i];

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    title: Text(
                      t.namaObat,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "Nama Pembeli : ${t.namaPembeli}\n"
                      "Jumlah : ${t.jumlah}\n"
                      "Total : ${Helpers.formatRupiah(t.totalHarga)}\n"
                      "Tanggal : ${t.tanggal}",
                    ),
                    trailing: const Icon(Icons.receipt_long),
                    onTap: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        AppRoutes.detail,
                        arguments: t,
                      );

                      if (result == true) {
                        _loadTransaksi(); // 🔥 refresh otomatis
                      }
                    },
                  ),
                );
              },
            ),
    );
  }

  /// 🔥 Dialog Konfirmasi Hapus Semua Transaksi (Sudah diperbaiki)
  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Hapus Semua Transaksi?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Tindakan ini akan menghapus seluruh riwayat pembelian dan tidak bisa dikembalikan.",
          ),
          actions: [
            // Tombol Batal (abu + teks putih)
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Batal"),
              onPressed: () => Navigator.pop(ctx),
            ),

            // Tombol Hapus (merah + teks putih)
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Hapus"),
              onPressed: () async {
                Navigator.pop(ctx); // tutup dialog

                await LocalTransaksi.clearTransaksi();
                setState(() => list.clear());

                Helpers.showSnackbar(
                  context,
                  "Semua transaksi berhasil dihapus!",
                  color: Colors.red,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
