import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/models/user_model.dart';
import '../../../data/datasource/local_user.dart';
import '../../../config/app_routes.dart';
import '../../../utils/validators.dart';
import '../../../widgets/custom_input.dart';
import '../../../widgets/custom_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _alamatController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final user = UserModel(
      nama: _namaController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      alamat: _alamatController.text,
      username: _usernameController.text,
      password: _passwordController.text,
    );

    await LocalUser.saveUser(user);
    await LocalUser.setLoggedIn(false);

    setState(() => _isLoading = false);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("Daftar Akun"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomInput(
                controller: _namaController,
                label: "Nama Lengkap",
                icon: Icons.person,
                validator: Validators.validateName,
              ),
              const SizedBox(height: 15),

              CustomInput(
                controller: _emailController,
                label: "Email",
                icon: Icons.email,
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 15),

              // Nomor telepon pakai TextFormField biasa (karena perlu inputFormatters)
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: Validators.validatePhone,
                decoration: InputDecoration(
                  labelText: "Nomor Telepon",
                  prefixIcon: const Icon(Icons.phone),
                  filled: true,
                  fillColor: Colors.blue.shade50.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              CustomInput(
                controller: _alamatController,
                label: "Alamat Lengkap",
                icon: Icons.home,
                validator: Validators.validateAlamat,
              ),
              const SizedBox(height: 15),

              CustomInput(
                controller: _usernameController,
                label: "Username",
                icon: Icons.account_circle,
                validator: Validators.validateUsername,
              ),
              const SizedBox(height: 15),

              // Password dengan toggle visibility
              CustomInput(
                controller: _passwordController,
                label: "Password",
                icon: Icons.lock,
                obscureText: _obscurePassword,
                validator: Validators.validatePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),

              const SizedBox(height: 25),

              CustomButton(
                text: "Daftar",
                loading: _isLoading,
                onPressed: _register,
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Sudah punya akun? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
