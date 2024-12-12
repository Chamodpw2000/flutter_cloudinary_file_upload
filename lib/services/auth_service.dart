import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<String> createAccountWithEmai(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return 'Account created';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }


Future<String> signInWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return 'Signed in';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

Future<bool> isUserLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  Future<String> getCurrentUser() async {
    var user = FirebaseAuth.instance.currentUser;
    return user?.email ?? 'No user';
  } 


}
