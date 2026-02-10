import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passHidden = true;

  // There could be multiple forms.
  // This assigns a unique jey to each form.
  // Also, it calls a validator function for each field in the form
  final _formKey = GlobalKey<FormState>();

  // An object used for extracting data from fields
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey, // ID for a particular form
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(),
                const SizedBox(height: 40),
                _username(),
                const SizedBox(
                  height: 40,
                ),
                _password(),
                const SizedBox(height: 40),
                _loginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  } // Build

  // Header
  Widget _header() {
    return const Text(
      'Welcome Back',
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  } // Header

  Widget _username() {
    return TextFormField(
      controller: _usernameController,
      decoration: const InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a valid username';
        }
        return null;
      },
    );
  }

  // Password
  Widget _password() {
    return TextFormField(
      controller: _passwordController, 
      obscureText: _passHidden,
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _passHidden = !_passHidden;
            });
          },
          icon: Icon(_passHidden ? Icons.visibility_off : Icons.visibility),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        return null;
        
      }, 
    );
  } // Password

  // Login Button
  Widget _loginButton() {
    return ElevatedButton(
      onPressed: _submitLogin,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: const Text('Login'),
    );
  } // Login

  void _submitLogin() {
    // Call all of the validator functions in the form
    // I am certain current state will not be null, so we use '!' before .validate()
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('login in user $username')),
      );
    }
  }
}
