import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../repositories/auth.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;

  Rx<User> user = Rx<User>(null);

  AuthController(this.authRepository) : assert(authRepository != null) {
    user.bindStream(authRepository.userChangeStream);
  }

  Future<void> createUserWithEmailAndPassword(
      String? email, String? password) async {
    await authRepository.createUserWithEmailAndPassword(email, password);
  }

  Future<void> signInWithEmailAndPassword(
      String? email, String? password) async {
    await authRepository.signInWithEmailAndPassword(email, password);
  }

  Future<void> submitEmailAuth(String? email) async {
    await authRepository.sendSignInLinkToEmail(email).then((value) => null);
  }

  Future<void> signOut() async {
    await authRepository.signOut();
  }
}
