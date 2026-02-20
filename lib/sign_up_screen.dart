import 'package:flutter/material.dart';
import 'package:responsive_design/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 8) return 'Must be at least 8 characters';
    
    // RegEx for: 1 Upper, 1 Lower, 1 Digit, 1 Symbol
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    if (!regex.hasMatch(value)) {
      return 'Requires: Uppercase, Lowercase, Digit, and Symbol';
    }
    return null;
  }

  void _submitSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _authService.signUp(
        email: _emailController.text, 
        password: _passwordController.text
      );
      if (!mounted) return;
      
      // Task 5: Success -> Back to Login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created! Please log in.'))
      );
      Navigator.pop(context); 
    } catch (e) {
      if (!mounted) return;

      // Task 4: Account exists -> Go to login with message
      if (e.toString().contains('account-exists')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account already exists. Please log in.'))
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red)
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => (value == null || !value.contains('@')) ? 'Enter a valid email' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: _validatePassword,
              ),
              const SizedBox(height: 40),
              _isLoading 
                ? const CircularProgressIndicator() 
                : ElevatedButton(onPressed: _submitSignUp, child: const Text('Create Account')),
            ],
          ),
        ),
      ),
    );
  }
}