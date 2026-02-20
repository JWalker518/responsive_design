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
      } 
      
      else if (e.code== 'wrong-password') {
        throw Exception('Wrong password provided.');
      } 
      
      else {
        throw Exception(e.message ?? 'An unkown error has occurred');
      }
    } catch (e) {
      throw Exception('System error: $e');
    }
  }


  // auth_service.dart additions
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Throw a specific message so the UI knows to redirect
        throw Exception('account-exists');
      } else if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      }
      throw Exception(e.message ?? 'An unknown error occurred');
    } catch (e) {
      throw Exception('System error: $e');
    }
  }

  // Sign-out Message
  Future<void> signOut() async {
    await _auth.signOut();
  }
}