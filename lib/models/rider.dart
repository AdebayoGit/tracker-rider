import 'package:cloud_firestore/cloud_firestore.dart';

class Rider {
  late String username;
  late String created;
  late String registrationVehicle;
  late String lastLogin;
  late String currentVehicle;

  Rider({
    required this.username,
    required this.created,
    required this.registrationVehicle,
    required this.lastLogin,
    required this.currentVehicle,
});


  factory Rider.fromSnap(DocumentSnapshot snap){
    return Rider(
        username: snap['username'] ?? '',
        created: '${snap['created'] ?? ''}',
        registrationVehicle: snap['registrationVehicle'] ?? '',
        lastLogin: '${snap['lastLogin'] ?? ''}',
        currentVehicle: snap['currentVehicle'] ?? '',
    );
  }
}