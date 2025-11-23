import 'package:flutter/material.dart';
import '../../../data/dummy/dummy_obat.dart';
import '../../../data/models/obat_model.dart';
import '../../../data/models/transaksi_model.dart';
import '../../../data/datasource/local_transaksi.dart';
import '../../../data/datasource/local_user.dart';
import '../../../widgets/custom_input.dart';
import '../../../widgets/custom_button.dart';
import '../../../utils/helpers.dart';
import '../../../utils/validators.dart';
import '../../../config/app_routes.dart';

class FormPembelianPage extends StatefulWidget {
  const FormPembelianPage({super.key});

  @override
  State<FormPembelianPage> createState() => _FormPembelianPageState();
}

class _FormPembelianPageState extends State<FormPembelianPage> {
  final _jumlahController = TextEditingController();
  final _catatanController = TextEditingController();
  final _nomorResepController = TextEditingController();

  ObatModel? obatDipilih;
  String namaPembeli = "";
  String metodePembelian = "langsung";

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  int totalHarga = 0;

  @override
  void initState() {
    super.initState();

    _jumlahController.addListener(_updateTotal);
    _loadUser();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is ObatModel) {
        setState(() {
          obatDipilih = args;
        });
      }
    });
  }

  void _updateTotal() {
    if (obatDipilih == null) return;

    final txt = _jumlahController.text.trim();
    if (txt.isEmpty || int.tryParse(txt) == null) {
      setState(() => totalHarga = 0);
      return;
    }

    final jumlah = int.parse(txt);
    setState(() => totalHarga = jumlah * obatDipilih!.harga);
  }

  Future<void> _loadUser() async {
    final user = await LocalUser.getUser();
    setState(() {
      namaPembeli = user?.nama ?? "Pengguna";
    });
  }

  @override
  void dispose() {
    _jumlahController.dispose();
    _catatanController.dispose();
    _nomorResepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Form Pembelian",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white), // <-- panah back putih
      ),

      backgroundColor: const Color(0xffE3F2FD),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NAMA PEMBELI
              _label("Nama Pembeli"),
              _infoBox(namaPembeli),

              const SizedBox(height: 20),

              // PILIH OBAT
              _label("Pilih Obat"),
              const SizedBox(height: 8),

              obatDipilih != null
                  ? _obatCard(obatDipilih!)
                  : DropdownButtonFormField<ObatModel>(
                      decoration: _dropdownDecoration(),
                      hint: const Text("Pilih obat"),
                      items: DummyObat.dataObat.map((obat) {
                        return DropdownMenuItem(
                          value: obat,
                          child: Text(obat.nama),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          obatDipilih = val;
                          _updateTotal();
                        });
                      },
                      validator: (val) =>
                          val == null ? "Pilih obat terlebih dahulu" : null,
                    ),

              const SizedBox(height: 20),

              // JUMLAH
              CustomInput(
                controller: _jumlahController,
                label: "Jumlah Pembelian",
                icon: Icons.add_shopping_cart,
                validator: Validators.validateJumlah,
              ),

              const SizedBox(height: 15),

              // TOTAL HARGA OTOMATIS
              if (totalHarga > 0)
                Text(
                  "Total Harga: ${Helpers.formatRupiah(totalHarga)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

              const SizedBox(height: 15),

              // CATATAN
              CustomInput(
                controller: _catatanController,
                label: "Catatan (opsional)",
                icon: Icons.note_alt_outlined,
              ),

              const SizedBox(height: 20),

              // METODE PEMBELIAN
              _label("Metode Pembelian"),

              RadioListTile(
                title: const Text("Pembelian Langsung"),
                value: "langsung",
                groupValue: metodePembelian,
                onChanged: (v) => setState(() => metodePembelian = v!),
              ),

              RadioListTile(
                title: const Text("Pembelian dengan Resep Dokter"),
                value: "resep",
                groupValue: metodePembelian,
                onChanged: (v) => setState(() => metodePembelian = v!),
              ),

              if (metodePembelian == "resep")
                CustomInput(
                  controller: _nomorResepController,
                  label: "Nomor Resep Dokter",
                  icon: Icons.receipt,
                  validator: Validators.validateNomorResep,
                ),

              const SizedBox(height: 25),

              CustomButton(
                text: "Konfirmasi Pembelian",
                loading: _loading,
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  Widget _infoBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _obatCard(ObatModel obat) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Image.asset(obat.gambar, width: 60, height: 60, fit: BoxFit.cover),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(obat.nama, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(obat.kategori, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                Text(
                  Helpers.formatRupiah(obat.harga),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (obatDipilih == null) return;

    setState(() => _loading = true);

    final jumlah = int.parse(_jumlahController.text.trim());
    final total = jumlah * obatDipilih!.harga;

    final transaksi = TransaksiModel(
      idTransaksi: Helpers.generateIdTransaksi(),
      idObat: obatDipilih!.id,
      namaObat: obatDipilih!.nama,
      namaPembeli: namaPembeli,
      jumlah: jumlah,
      hargaSatuan: obatDipilih!.harga,
      totalHarga: total,
      metodePembelian: metodePembelian,
      nomorResep: metodePembelian == "resep" ? _nomorResepController.text.trim() : null,
      tanggal: Helpers.formatTanggal(DateTime.now()),
      status: "selesai",
    );

    await LocalTransaksi.tambahTransaksi(transaksi);

    setState(() => _loading = false);

    if (!mounted) return;

    Helpers.showSnackbar(context, "Pembelian berhasil!", color: Colors.green);

    await Future.delayed(const Duration(milliseconds: 600));

    Navigator.pushReplacementNamed(context, AppRoutes.riwayat);
  }
}
