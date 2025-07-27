import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final _auth = FirebaseAuth.instance;

  Future<User?> loginUser(String email, String password)async{
    return await _auth.signInWithEmailAndPassword(email: email, password: password).then((result) => result.user);
  }

  Future<User?> createUser(String email, String password) async {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((result) => result.user);
  }
}