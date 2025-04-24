import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signUp (String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

Future<UserCredential> signIn(String email, String password) {
  return _auth.signInWithEmailAndPassword(email: email, password:password);
}

Future<void> signOut(){
  return _auth.signOut();
}

User? getCurrentUser(){
  return _auth.currentUser;
}

String getCurrentUid() {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'NO_CURRENT_USER',
        message: 'No user is currently signed in.',
      );
    }
    return user.uid;
  }

Stream<User?> authStateChanges(){
  return _auth.authStateChanges();
}

Future<void> sendPasswordResetEmail(String email) {
  return _auth.sendPasswordResetEmail(email: email);
}

}