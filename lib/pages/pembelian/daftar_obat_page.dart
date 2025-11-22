import 'package:flutter/material.dart';
import '../../../data/dummy/dummy_obat.dart';
import '../../../data/models/obat_model.dart';
import '../../../config/app_routes.dart';
import '../../../utils/helpers.dart';

class DaftarObatPage extends StatelessWidget {
  const DaftarObatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Obat"),
        backgroundColor: Colors.blue.shade700,
      ),
      backgroundColor: const Color(0xffE3F2FD),

      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: DummyObat.dataObat.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.63,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          ObatModel obat = DummyObat.dataObat[index];

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      obat.gambar,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  obat.nama,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  obat.kategori,
                  style: TextStyle(
                    color: Colors.blue.shade600,
                  ),
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

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.pembelian,
                        arguments: obat,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Beli"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
