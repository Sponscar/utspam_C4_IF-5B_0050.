import 'package:flutter/material.dart';
import 'package:aplikasi_apotek/config/app_routes.dart';
import 'package:aplikasi_apotek/data/datasource/local_user.dart';
import 'package:aplikasi_apotek/data/dummy/dummy_obat.dart';
import 'package:aplikasi_apotek/data/models/obat_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String namaUser = "";

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await LocalUser.getUser();
    setState(() {
      namaUser = user?.nama ?? "Pengguna";
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<ObatModel> rekomendasiObat = DummyObat.dataObat;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =======================
                // HEADER USER
                // =======================
                Text(
                  "Halo, $namaUser 👋",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Selamat Datang di Go-Healthy",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue.shade600,
                  ),
                ),

                const SizedBox(height: 25),

                // =======================
                // MENU UTAMA
                // =======================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _menuItem(
                      icon: Icons.medical_services_rounded,
                      title: "Beli Obat",
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.pembelian,
                      ),
                    ),
                    _menuItem(
                      icon: Icons.receipt_long_rounded,
                      title: "Riwayat",
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.riwayat,
                      ),
                    ),
                    _menuItem(
                      icon: Icons.person_rounded,
                      title: "Profil",
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.profile,
                      ),
                    ),
                    _menuItem(
                      icon: Icons.logout_rounded,
                      title: "Logout",
                      onTap: () async {
                        await LocalUser.logout();
                        if (!mounted) return;
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // =======================
                // REKOMENDASI OBAT
                // =======================
                Text(
                  "Rekomendasi Obat",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 15),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rekomendasiObat.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 240,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final obat = rekomendasiObat[index];

                    return _obatCard(obat, context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========================================================
  // WIDGET: MENU UTAMA
  // ========================================================
  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 30,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  // ========================================================
  // WIDGET: CARD OBAT
  // ========================================================
  Widget _obatCard(ObatModel obat, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // GAMBAR OBAT
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.asset(
              obat.gambar,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  obat.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  obat.kategori,
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Rp ${obat.harga}",
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.pembelian,
                          arguments: obat);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text("Beli"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
