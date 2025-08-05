import 'package:flutter/material.dart';
import 'package:robotics/screens/auth/login_screen.dart';
import 'package:robotics/service/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _firebaseService.signUp(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(iconTheme: const IconThemeData(color: Colors.black)),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/logo.png', height: 150),
              const SizedBox(height: 20),

              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "User Name"),
                validator: (value) =>
                    value!.isEmpty ? "Username is required" : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                    value!.isEmpty ? "Email is required" : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Password is required" : null,
              ),

              const SizedBox(height: 15),

              if (_errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isLoading ? null : _registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0A5EFE),
                  fixedSize: const Size(285, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Register",
                        style: TextStyle(color: Colors.white),
                      ),
              ),

              const SizedBox(height: 15),

              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: 'Already have an account? ',
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0A5EFE),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
