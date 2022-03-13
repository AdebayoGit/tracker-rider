import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class Trip {
  late String riderId;
  late String tripId;
  late String startTime;
  String? endTime;
  List<LocationData> stops;
  late List<LocationData> locationData;

  Trip({
    required this.riderId,
    required this.tripId,
    required this.startTime,
    this.endTime,
    this.stops = const <LocationData>[],
    required this.locationData,
  });

  factory Trip.fromSnap(DocumentSnapshot snap) {
    return Trip(
      tripId: snap.id,
      riderId: snap['riderId'],
      startTime: snap['startTime'],
      endTime: snap['endTime'],
      locationData: snap['locationData'],
      stops: snap['stops'],
    );
  }

  Map<String, dynamic> toJson() => {
    'riderId': riderId,
    'startTime': startTime,
    'endTime': endTime,
    'locationData': locationData,
    'stops': stops,
  };
}
