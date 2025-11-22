import 'package:flutter/material.dart';
import '../../../data/models/obat_model.dart';
import '../../../data/models/transaksi_model.dart';
import '../../../data/datasource/local_transaksi.dart';
import '../../../widgets/custom_input.dart';
import '../../../widgets/custom_button.dart';
import '../../../utils/helpers.dart';
import '../../../utils/validators.dart';

class FormPembelianPage extends StatefulWidget {
  const FormPembelianPage({super.key});

  @override
  State<FormPembelianPage> createState() => _FormPembelianPageState();
}

class _FormPembelianPageState extends State<FormPembelianPage> {
  final _jumlahController = TextEditingController();
  final _catatanController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    // Menerima data obat dari HomePage
    final ObatModel obat = ModalRoute.of(context)!.settings.arguments as ObatModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Form Pembelian",
          style: TextStyle(color: Colors.blue.shade800),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue.shade800),
      ),

      backgroundColor: const Color(0xffE3F2FD),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ======================== NAMA OBAT ===========================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        obat.gambar,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            obat.nama,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            obat.kategori,
                            style: TextStyle(
                                fontSize: 14, color: Colors.blue.shade600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            Helpers.formatRupiah(obat.harga),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ======================== INPUT JUMLAH ===========================
              CustomInput(
                controller: _jumlahController,
                label: "Jumlah Pembelian",
                icon: Icons.add_shopping_cart,
                validator: Validators.validateJumlah,
              ),

              const SizedBox(height: 15),

              // ======================== INPUT CATATAN (OPSIONAL) =================
              CustomInput(
                controller: _catatanController,
                label: "Catatan (opsional)",
                icon: Icons.note_alt_outlined,
              ),

              const SizedBox(height: 30),

              // ======================== TOMBOL BELI =============================
              CustomButton(
                text: "Konfirmasi Pembelian",
                loading: _loading,
                onPressed: () => _prosesPembelian(obat),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _prosesPembelian(ObatModel obat) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final int jumlah = int.parse(_jumlahController.text.trim());
    final int total = jumlah * obat.harga;

    final transaksi = TransaksiModel(
      idTransaksi: Helpers.generateIdTransaksi(),
      idObat: obat.id,
      namaObat: obat.nama,
      jumlah: jumlah,
      totalHarga: total,
      tanggal: Helpers.formatTanggal(DateTime.now()),
    );

    await LocalTransaksi.tambahTransaksi(transaksi);

    setState(() => _loading = false);

    if (!mounted) return;

    // Kembali ke halaman sebelumnya (Riwayat atau Home)
    Navigator.pop(context, true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Pembelian berhasil disimpan!"),
        backgroundColor: Colors.green,
      ),
    );
  }
}
