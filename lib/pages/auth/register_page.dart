import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/models/user_model.dart';
import '../../../data/datasource/local_user.dart';
import '../../../config/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _alamatController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final user = UserModel(
      nama: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      alamat: _alamatController.text,
      username: _usernameController.text,
      password: _passwordController.text,
    );

    await LocalUser.saveUser(user);
    await LocalUser.setLoggedIn(true);

    setState(() => _isLoading = false);

    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // NAMA LENGKAP
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Lengkap",
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Nama lengkap wajib diisi";
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // EMAIL
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Email wajib diisi";
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                    return "Format email tidak valid";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // NOMOR TELEPON
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Nomor Telepon",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return "Nomor telepon wajib diisi";
                  if (v.length < 10) return "Nomor telepon tidak valid";
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // ALAMAT
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(
                  labelText: "Alamat Lengkap",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Alamat wajib diisi";
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // USERNAME
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Username wajib diisi";
                  if (v.length < 4) return "Username minimal 4 karakter";
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // PASSWORD
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Password wajib diisi";
                  if (v.length < 6) return "Password minimal 6 karakter";
                  return null;
                },
              ),
              const SizedBox(height: 25),

              // TOMBOL DAFTAR
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Daftar"),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
                child: const Text("Sudah punya akun? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
