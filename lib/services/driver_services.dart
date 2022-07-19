import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/driver.dart';
import '../models/status.dart';
import 'auth_services.dart';

class DriverServices {
  static DriverServices? _instance;

  DriverServices._();

  static DriverServices get instance => _instance ??= DriverServices._();

  late FirebaseFirestore _store;

  late DocumentReference _driversDoc;

  DriverServices(){
    _store = FirebaseFirestore.instance;

    _driversDoc = _store.collection('riders').doc(AuthServices().driversId);
  }

  Future<Status> getCurrentDriver() async {
    try {
      return _driversDoc.get().then((value) {
        return Success(response: Driver.fromSnapshot(value));
      });
    } on Exception catch (e) {
      return Failure(code: "100", response: e as String);
    }
  }

  Future<void> recordDriverLastTrip(String tripId) async {
    try {
      return _driversDoc.update({
        'lastTrip': tripId,
        'totalTrips': FieldValue.increment(1),
      });
    } on Exception catch (e) {
      recordDriverLastTrip(tripId);
    }

  }
}