import 'package:firebase_auth/firebase_auth.dart';

/// Authentication service

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  // A stream used for checking if the user is signed in
  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  // Password reset
  Future<String> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      return 'Operation successful.';
    } on FirebaseAuthException catch (e) {
      return 'Failed with error message: ${e.code}.';
    } catch (e) {
      print(e.toString());
    }
    return 'An error occurred.';
  }

  // Sign out
  Future<String> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return 'Operation successful.';
    } on FirebaseAuthException catch (e) {
      return 'Failed with error message: ${e.code}.';
    } catch (e) {
      print(e.toString());
    }
    return 'An error occurred.';
  }

  // Sign in
  Future<String> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return 'Signed in successfully.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return 'Invalid email.';
      }
      if (e.code == 'user-not-found') {
        return 'No user with this email-password combination exists.';
      }
      return 'Failed with error message: ${e.code}.';
    } catch (e) {
      print(e.toString());
    }
    return 'An error occurred.';
  }

  // Register
  Future<String> signUp(String email, String password) async {
    try {
      final firebaseUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      if (firebaseUser == null) {
        return 'An error occurred while creating the account.';
      }
      firebaseUser.user.sendEmailVerification();
      return 'Registered successfully.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The provided password is too weak.';
      }
      if (e.code == 'email-already-in-use') {
        return 'An account already exists on that email address.';
      }
      return 'Failed with error message: ${e.code}.';
    } catch (e) {
      print(e.toString());
    }
    return 'An error occurred.';
  }
}
