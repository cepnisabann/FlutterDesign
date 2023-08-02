// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:injectable/injectable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../base/base_view_model.dart';

@injectable
class LoginPageViewModel extends BaseViewModel {
  LoginPageViewModel();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
  }

  Future registerUser(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    print(userCredential);

    return;
    // Registration successful, handle the user data or navigation to the next screen here
  }

  Future resetPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }
}
