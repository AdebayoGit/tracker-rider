import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/driver.dart';
import '../models/status.dart';

class DriverServices {

  late FirebaseFirestore _store;

  late CollectionReference _driversCollection;

  DriverServices(){
    _store = FirebaseFirestore.instance;

    _driversCollection = _store.collection('riders');
  }


  Future<Object?> getCurrentDriver(String uid) async {
    try {
      return _driversCollection.doc(uid).get().then((value) {
        return Success(response: Driver.fromSnapshot(value));
      });
    } on Exception catch (e) {
      return Failure(code: "100", errorResponse: e as String);
    }
  }
}