import 'package:flutter/material.dart';
import '../../../data/models/transaksi_model.dart';
import '../../../data/datasource/local_transaksi.dart';
import '../../../utils/helpers.dart';
import '../../../config/app_routes.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! TransaksiModel) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Detail Pembelian"),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text("Transaksi tidak ditemukan")),
      );
    }

    final transaksi = args;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pembelian"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xffE3F2FD),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            _item("Nama Obat", transaksi.namaObat),
            _item("Nama Pembeli", transaksi.namaPembeli),
            _item("Jumlah", transaksi.jumlah.toString()),
            _item("Harga Satuan", Helpers.formatRupiah(transaksi.hargaSatuan)),
            _item("Total Harga", Helpers.formatRupiah(transaksi.totalHarga)),
            _item("Tanggal Pembelian", transaksi.tanggal),
            _item("ID Transaksi", transaksi.idTransaksi),
            _item("Metode Pembelian",
                transaksi.metodePembelian == "langsung"
                    ? "Pembelian Langsung"
                    : "Resep Dokter"),
            if (transaksi.nomorResep != null)
              _item("Nomor Resep", transaksi.nomorResep!),

            const SizedBox(height: 22),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.editTransaksi,
                  arguments: transaksi,
                );
              },
              child: const Text("Edit Transaksi"),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await LocalTransaksi.hapusTransaksi(transaksi.idTransaksi);

                // kirim signal refresh ke halaman sebelumnya
                Navigator.pop(context, true);

                Helpers.showSnackbar(context, "Transaksi telah dihapus!", color: Colors.red);
              },

              child: const Text("Hapus / Batalkan Transaksi"),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Kembali ke Riwayat"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16))
        ],
      ),
    );
  }
}
