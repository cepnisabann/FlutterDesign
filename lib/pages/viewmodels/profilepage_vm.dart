import 'package:design/base/base_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfilePageViewModel extends BaseViewModel {
  ProfilePageViewModel();

  Future<User?> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  //signout
  Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }
}
