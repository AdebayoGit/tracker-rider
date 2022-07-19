import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class Trip {
  late DateTime createdAt;
  late Map<String, dynamic> start;
  late Map<String, dynamic> stop;
  late List<Map<String, dynamic>> pauses;
  late String initialRemarks;
  String? endTime;
  List<LocationData> stops;
  late List<LocationData> locationData;

  Trip({

    this.endTime,
    this.stops = const <LocationData>[],
    required this.locationData,
  });

  factory Trip.fromSnap(DocumentSnapshot snap) {
    return Trip(
      endTime: snap['endTime'],
      locationData: snap['locationData'],
      stops: snap['stops'],
    );
  }

  Map<String, dynamic> toJson() => {
    'endTime': endTime,
    'locationData': locationData,
    'stops': stops,
  };
}
