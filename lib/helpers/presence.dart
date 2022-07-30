import 'package:firebase_database/firebase_database.dart';

class Presence {
  static final Presence instance = Presence._();
  final FirebaseDatabase db = FirebaseDatabase.instance;
  late final DatabaseReference ref;

  Presence._(){
    ref = db.ref('presence');
  }

  Future<void> updateUserPresence(String uid) async {

    await _goOnline(uid);

    _goOffline(uid);
  }

  Future<void> _goOnline(String uid) async{


    Map<String, dynamic> presenceStatusTrue = {
      'presence': true,
      'last_seen': DateTime.now().toString(),
    };

    await ref.child(uid).update(presenceStatusTrue)
        .catchError((e) => Future.delayed(const Duration(minutes: 2), () => _goOnline(uid)));

  }

  Future<void> _goOffline(String uid) async{

    Map<String, dynamic> presenceStatusFalse = {
      'presence': false,
      'last_seen': DateTime.now().toString(),
    };

    await ref.child(uid).onDisconnect().update(presenceStatusFalse);
  }

  Future<void> signedOut(String uid) async{

    Map<String, dynamic> presenceStatusFalse = {
      'presence': false,
      'last_seen': DateTime.now().toString(),
    };

    await ref.child(uid).update(presenceStatusFalse);
  }

  Future<bool> checkForMultipleAuth(String username) async{

    final DataSnapshot snapshot = await ref.child(username).get();

    if(snapshot.exists){
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      return values['presence'];
    } else {
      return false;
    }
  }
}
