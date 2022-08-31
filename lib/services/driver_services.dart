import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../components/progress_dialog.dart';
import '../helpers/presence.dart';
import '../helpers/response.dart';
import '../main.dart';
import '../models/driver.dart';
import '../views/auth_view.dart';
import '../views/custom_navigator.dart';

class DriverServices extends GetxService {
  late FirebaseAuth _auth;

  late FirebaseFunctions _functions;

  late FirebaseFirestore _store;

  late final Presence presence;

  late CollectionReference _drivers;

  late User user;

  late Driver? driver;

  @override
  onInit() {
    _auth = FirebaseAuth.instance;

    _functions = FirebaseFunctions.instance;

    _store = FirebaseFirestore.instance;

    presence = Presence.instance;

    _drivers = _store.collection('riders');

    super.onInit();
  }

  @override
  Future<void> onReady() async {
    listenForAuthChanges();

    super.onReady();
  }

  Future<void> _getCurrentDriver() async {
    try {
      driver = await _drivers
          .doc(user.uid)
          .get()
          .then((value) => Driver.fromSnapshot(value));
      bool online = await presence.checkForMultipleAuth(user.uid);
      if (online) {
        await _auth.signOut();
        ResponseHelpers.showSnackbar("Multiple auth detected!!!");
      } else {
        presence.updateUserPresence(user.uid);
        Get.offAll(() => const CustomNavigator(),
          transition: Transition.fadeIn,
          duration: const Duration(seconds: 1),
        );
      }
    } on Exception catch (e) {
      await signOut();
      ResponseHelpers.showSnackbar(e.toString());
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
      ResponseHelpers.showSnackbar(e.toString());
    }
  }

  Future<void> signIn(String username, String password) async {
    Get.dialog(const ProgressDialog(status: 'Please wait...'),
        barrierDismissible: false);
    try {
      HttpsCallable callable = _functions.httpsCallable('signin');
      await callable.call(<String, dynamic>{
        'username': username,
        'password': password,
      }).then((value) async {
        try {
          user = await _auth
              .signInWithCustomToken(value.data["token"])
              .then((value) => value.user!);
          ResponseHelpers.showSnackbar(
              'Driver ${user.uid} signed in successfully');
        } on FirebaseAuthException catch (e) {
          ResponseHelpers.showSnackbar(e.message!);
        }
      });
    } on FirebaseFunctionsException catch (e) {
      ResponseHelpers.showSnackbar(e.message!);
    } catch (e) {
      ResponseHelpers.showSnackbar(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await presence.signedOut(driver!.username);
      RootWidget.restartApp(Get.context!);
    } on FirebaseAuthException catch (e) {
      ResponseHelpers.showSnackbar(e.message ?? 'Unable to sign out');
    }
  }

  void listenForAuthChanges() {
    _auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        Get.offAll(() => AuthView(),
          transition: Transition.fadeIn,
          duration: const Duration(seconds: 1),
        );
      } else {
        this.user = user;
        await _getCurrentDriver();
      }
    });
  }
}
