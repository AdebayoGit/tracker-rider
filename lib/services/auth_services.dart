import 'package:firebase_auth/firebase_auth.dart';
import 'package:rider/models/status.dart';

class AuthServices{


  ///AuthServices(){}

  static Future<Object> signIn() async {
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      return Success(response: userCredential);
    } on FirebaseAuthException catch  (e) {
      return Failure(code: e.code as int, errorResponse: e.message as String);
    }
  }
}