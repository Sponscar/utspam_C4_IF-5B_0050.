import 'package:flutter/material.dart';
import '../../../data/datasource/local_user.dart';
import '../../../config/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final user = await LocalUser.getUser();

    if (user == null) {
      setState(() {
        _errorMessage = "Belum ada akun terdaftar!";
        _isLoading = false;
      });
      return;
    }

    // Cocokkan username dan password
    if (_usernameController.text == user.username &&
        _passwordController.text == user.password) {
      await LocalUser.setLoggedIn(true);

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      setState(() {
        _errorMessage = "Username atau password salah.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // USERNAME
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Username wajib diisi" : null,
              ),
              const SizedBox(height: 15),

              // PASSWORD
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) =>
                    v == null || v.isEmpty ? "Password wajib diisi" : null,
              ),
              const SizedBox(height: 20),

              // ERROR MESSAGE
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 20),

              // LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login"),
                ),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.register);
                },
                child: const Text("Belum punya akun? Daftar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
