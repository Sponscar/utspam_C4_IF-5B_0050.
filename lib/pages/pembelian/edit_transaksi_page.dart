import 'package:flutter/material.dart';
import '../../../data/models/transaksi_model.dart';
import '../../../data/datasource/local_transaksi.dart';
import '../../../utils/helpers.dart';
import '../../../utils/validators.dart';

class EditTransaksiPage extends StatefulWidget {
  const EditTransaksiPage({super.key});

  @override
  State<EditTransaksiPage> createState() => _EditTransaksiPageState();
}

class _EditTransaksiPageState extends State<EditTransaksiPage> {
  final _formKey = GlobalKey<FormState>();

  final jumlahController = TextEditingController();
  final catatanController = TextEditingController();
  final nomorResepController = TextEditingController();

  late TransaksiModel transaksi;
  String metodePembelian = "langsung";
  int totalBaru = 0;

  @override
  void initState() {
    super.initState();
    // argument diterima setelah build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is TransaksiModel) {
        transaksi = args;

        jumlahController.text = transaksi.jumlah.toString();
        catatanController.text = transaksi.catatan ?? "";
        nomorResepController.text = transaksi.nomorResep ?? "";
        metodePembelian = transaksi.metodePembelian;

        _updateTotal();
        setState(() {});
      }
    });

    jumlahController.addListener(_updateTotal);
  }

  void _updateTotal() {
    if (jumlahController.text.isEmpty) return;

    final j = int.tryParse(jumlahController.text) ?? 0;
    setState(() {
      totalBaru = j * transaksi.hargaSatuan;
    });
  }

  @override
  void dispose() {
    jumlahController.dispose();
    catatanController.dispose();
    nomorResepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted || jumlahController.text.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Transaksi"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // JUMLAH
              Text("Jumlah Pembelian",
                  style: labelStyle),
              const SizedBox(height: 6),
              TextFormField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                decoration: inputDecoration("Jumlah"),
                validator: Validators.validateJumlah,
              ),

              const SizedBox(height: 20),

              // CATATAN
              Text("Catatan (opsional)", style: labelStyle),
              const SizedBox(height: 6),
              TextFormField(
                controller: catatanController,
                decoration: inputDecoration("Catatan"),
              ),

              const SizedBox(height: 20),

              // METODE PEMBELIAN
              Text("Metode Pembelian", style: labelStyle),

              RadioListTile(
                title: const Text("Pembelian Langsung"),
                value: "langsung",
                groupValue: metodePembelian,
                onChanged: (v) => setState(() => metodePembelian = v!),
              ),

              RadioListTile(
                title: const Text("Pembelian Dengan Resep Dokter"),
                value: "resep",
                groupValue: metodePembelian,
                onChanged: (v) => setState(() => metodePembelian = v!),
              ),

              if (metodePembelian == "resep")
                TextFormField(
                  controller: nomorResepController,
                  decoration: inputDecoration("Nomor Resep"),
                  validator: Validators.validateNomorResep,
                ),

              const SizedBox(height: 20),

              // TOTAL BARU
              Text(
                "Total Harga Baru: ${Helpers.formatRupiah(totalBaru)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 25),

              // BUTTON SIMPAN
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: _simpanPerubahan,
                child: const Text("Simpan Perubahan"),
              ),

              const SizedBox(height: 12),

              // BUTTON BATAL
              TextButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Batal (Kembali Tanpa Mengubah)"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _simpanPerubahan() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = TransaksiModel(
      idTransaksi: transaksi.idTransaksi,
      idObat: transaksi.idObat,
      namaObat: transaksi.namaObat,
      namaPembeli: transaksi.namaPembeli,
      jumlah: int.parse(jumlahController.text),
      hargaSatuan: transaksi.hargaSatuan,
      totalHarga: totalBaru,
      tanggal: transaksi.tanggal,
      metodePembelian: metodePembelian,
      catatan: catatanController.text,
      nomorResep:
          metodePembelian == "resep" ? nomorResepController.text.trim() : null,
      status: transaksi.status,
    );

    await LocalTransaksi.editTransaksi(updated);

    Helpers.showSnackbar(context, "Transaksi berhasil diperbarui!",
        color: Colors.green);

    // kembali ke detail page & refresh
    Navigator.pop(context, updated);
  }

  // STYLE REUSABLE
  InputDecoration inputDecoration(String lbl) {
    return InputDecoration(
      labelText: lbl,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  TextStyle get labelStyle => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade800,
      );
}
