import 'package:flutter/material.dart';
import '../../../data/datasource/local_user.dart';
import '../../../config/app_routes.dart';
import '../../../utils/validators.dart';
import '../../../widgets/custom_input.dart';
import '../../../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading = false;
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
      backgroundColor: Colors.white,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),

              // LOGO 
              SizedBox(
                height: 150,
                child: Image.asset(
                  "assets/images/apotek_logo.png",
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 10),

              // TITLE
              Text(
                "Selamat Datang di Go-Healthy",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Silakan masuk dengan akun Anda",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              // CUSTOM INPUT USERNAME
              CustomInput(
                controller: _usernameController,
                label: "Username",
                icon: Icons.person,
                validator: Validators.validateUsername,
              ),

              const SizedBox(height: 18),

              // CUSTOM INPUT PASSWORD
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

              const SizedBox(height: 15),

              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 20),

              // CUSTOM BUTTON LOGIN
              CustomButton(
                text: "Login",
                loading: _isLoading,
                onPressed: _login,
              ),

              const SizedBox(height: 20),

              // LINK TO REGISTER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                    child: Text(
                      "Daftar",
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
