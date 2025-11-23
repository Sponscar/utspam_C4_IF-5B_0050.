import 'package:flutter/material.dart'; 
import '../../../data/datasource/local_user.dart';
import '../../../config/app_routes.dart';
import '../../../data/dummy/dummy_obat.dart';
import '../../../data/models/obat_model.dart';
import '../../../utils/helpers.dart';  // 🔥 import helpers

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
    return Scaffold(
      backgroundColor: const Color(0xffE3F2FD),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Text(
                "Halo, $namaUser 👋",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "Selamat Datang di Go-Healthy",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue.shade700,
                ),
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _menuButton(
                    icon: Icons.medical_services_outlined,
                    label: "Beli Obat",
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.daftarObat),
                  ),
                  _menuButton(
                    icon: Icons.receipt_long,
                    label: "Riwayat",
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.riwayat),
                  ),
                  _menuButton(
                    icon: Icons.person,
                    label: "Profil",
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.profile),
                  ),

                  // 🔥 LOGOUT + KONFIRMASI
                  _menuButton(
                    icon: Icons.logout,
                    label: "Logout",
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text("Konfirmasi Logout"),
                            content: const Text(
                                "Apakah kamu yakin ingin keluar dari akun?"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Batal"),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Logout"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        await LocalUser.logout();
                        if (!mounted) return;
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Text(
                "Rekomendasi Obat",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),

              const SizedBox(height: 15),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: DummyObat.dataObat.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.63,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  ObatModel obat = DummyObat.dataObat[index];
                  return _obatCard(obat, context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onTap,
          child: CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Icon(icon, size: 30, color: Colors.blue.shade700),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.blue.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _obatCard(ObatModel obat, BuildContext context) {
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
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.image_not_supported, size: 40),
                ),
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
              fontSize: 14,
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
                padding: const EdgeInsets.symmetric(vertical: 10),
                foregroundColor: Colors.white,
              ),
              child: const Text("Beli"),
            ),
          ),
        ],
      ),
    );
  }
}
