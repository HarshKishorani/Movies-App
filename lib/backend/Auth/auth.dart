import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future EmailPassSignIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (error) {
      return error.message;
    } catch (error) {
      return error;
    }
  }

  Future EmailPassSignUp(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (error) {
      return error.message;
    } catch (error) {
      return error;
    }
  }

  Future SignOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
