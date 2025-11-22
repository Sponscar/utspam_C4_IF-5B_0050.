import 'package:flutter/material.dart';
import '../../../data/datasource/local_transaksi.dart';
import '../../../data/models/transaksi_model.dart';
import '../../../utils/helpers.dart';

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
                    title: Text(t.namaObat),
                    subtitle: Text(
                      "Jumlah: ${t.jumlah}   • Total: ${Helpers.formatRupiah(t.totalHarga)}\n${t.tanggal}",
                    ),
                  ),
                );
              },
            ),
    );
  }
}
