import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/driver.dart';
import '../models/status.dart';

class DriverServices {
  static DriverServices? _instance;

  DriverServices._(){
    _store = FirebaseFirestore.instance;

    _drivers = _store.collection('riders');
  }

  static DriverServices get instance => _instance ??= DriverServices._();

  late Driver? driver;

  late FirebaseFirestore _store;

  late CollectionReference _drivers;

  Future<Status> getCurrentDriver({required String id}) async {
    try {
      driver = await _drivers.doc(id).get().then((value) => Driver.fromSnapshot(value));
      return Success(response: driver!);
    } on Exception catch (e) {
      return Failure(code: "100", response: e as String);
    }
  }

  Future<void> recordDriverLastTrip(String tripId) async {
    try {
      return driver?.ref.update({
        'lastTrip': tripId,
        'totalTrips': FieldValue.increment(1),
      });
    } on Exception catch (e) {
      recordDriverLastTrip(tripId);
    }

  }
}