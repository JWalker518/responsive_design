import 'package:flutter/material.dart';
import 'package:responsive_design/auth_service.dart';
import 'package:responsive_design/profile_card.dart';

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
  
  // spinning circle feedback
  bool _isLoading = false;

  final _authService = AuthService();

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
                
                // show a spinning circle while logging in
                _isLoading ? const CircularProgressIndicator(): _loginButton(),
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
  } // loginButton

  void _submitLogin() async {
    // Call all of the validator functions in the form
    // I am certain current state will not be null, so we use '!' before .validate()
    if (!_formKey.currentState!.validate()) return;
  
    // Start spinning circle progress indicator
    setState(() => _isLoading = true);

    final email = _usernameController.text;
    final password = _passwordController.text;

    try { 
      await _authService.signIn(email: email, password: password);
    
      // from the inherited State class, we can check to make sure
      // the signing widget is still on the screen
      if (!mounted) return; // TODO signOut?


      // if success, then go back to ProfileCard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ProfileCard())
      );
    } catch (e) {
      if (!mounted) return; // TODO error popup (Toast)

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red,)
      
      );
    } 
    // Finally executed no matter what
    finally {
      // stops spinning circle widget 
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }

  } // submitLogin
}
