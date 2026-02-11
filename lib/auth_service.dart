import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // We keep the instance private so only this class handles Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign-in Method
  Future<User?> signIn (
    // Braces signify named parameters
    {
    required String email,
    required String password
    }
  ) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase errors (Upper Level requirement)
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code== 'wrong-password') {
        throw Exception('Wrong password provided.');
      } else {
        throw Exception(e.message ?? 'An unkown error has occurred');
      }
    } catch (e) {
      throw Exception('System error: $e');
    }
  }

  // Sign-out Message
  Future<void> signOut() async {
    await _auth.signOut();
  }
}