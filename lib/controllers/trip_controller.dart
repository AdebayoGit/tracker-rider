import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:rider/components/progress_dialog.dart';
import 'package:rider/services/location_services.dart';
import 'package:rider/services/trip_services.dart';

import '../models/status.dart';

class TripController extends GetxController {
  final Stopwatch _stopwatch = Stopwatch();

  final LocationServices _location = LocationServices();

  final TripServices _trips = TripServices();

  final TextEditingController remarks = TextEditingController();

///Todo: uncomment to handle control of location stream
  // late final StreamSubscription<LocationData> _locationStream;

  late Timer _timer;

  late String _tripId;

  RxString days = '0'.obs,
      hours = '00'.obs,
      minutes = '00'.obs,
      seconds = '00'.obs;

  late RxInt currentWidget = 0.obs;

  void tripControl() {
    switch (currentWidget.value) {
      case 1:
        {
          pauseTrip();
        }
        break;
      case 2:
        {
          restartTrip();
        }
        break;
      default:
        {
          startTrip();
        }
        break;
    }
  }

  Future<void> startTrip() async {
    Get.back();
    showPleaseWaitDialog();
    await _location.checkLocationPermission();
    Object response =
        _trips.createTrip(await _location.getCurrentLocation(), remarks.text);
    if (response is Success) {
      remarks.clear();
      _tripId = response.response as String;
      Get.back();
      Get.showSnackbar(const GetSnackBar(
        message: 'Bon voyage!',
        duration: Duration(milliseconds: 500),
      ));
    } else {
      Failure failure = response as Failure;
      Get.back();
      Get.showSnackbar(GetSnackBar(
        title: failure.code,
        message: failure.errorResponse.toString(),
        duration: const Duration(seconds: 2),
      ));
      return;
    }
    tripUI(1);
    startTimer();
    _getLocationUpdates();
  }

  Future<void> restartTrip() async {
    Get.back();
    showPleaseWaitDialog();
    await _location.checkLocationPermission();
    tripUI(1);
    startTimer();
    Get.back();
  }

  Future<void> pauseTrip() async {
    Get.back();
    showPleaseWaitDialog();
    Object response = _trips.pauseTrip(
        _tripId, remarks.text, await _location.getCurrentLocation());
    remarks.clear();
    if (response is Failure) {
      Failure failure = response;
      Get.back();
      Get.showSnackbar(GetSnackBar(
        title: failure.code,
        message: failure.errorResponse.toString(),
        duration: const Duration(seconds: 2),
      ));
      return;
    }
    Get.back();
    Get.showSnackbar(const GetSnackBar(
      message: "We'll be waiting!",
      duration: Duration(milliseconds: 500),
    ));
    tripUI(2);
    pauseTimer();
  }

  Future<void> stopTrip() async {
    //Get.back();
    showPleaseWaitDialog();
    Object? response = _trips.stopTrip(_tripId, await _location.getCurrentLocation());
    remarks.clear();
    if (response != null) {
      Failure failure = response as Failure;
      Get.back();
      Get.showSnackbar(GetSnackBar(
        title: failure.code,
        message: failure.errorResponse.toString(),
        duration: const Duration(seconds: 2),
      ));
      return;
    }
    Get.back();
    Get.showSnackbar(GetSnackBar(
      message: "Trip $_tripId successfully completed",
      duration: const Duration(milliseconds: 500),
    ));
    tripUI(0);
    resetTimer();
  }

  void startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      setDisplay(_stopwatch);
    });
  }

  void pauseTimer() {
    _stopwatch.stop();
    _timer.cancel();
  }

  void resetTimer() {
    _stopwatch.stop();
    _stopwatch.reset();
    _timer.cancel();
    setDisplay(_stopwatch);
  }

  void setDisplay(Stopwatch _stopwatch) {
    seconds.value =
        _stopwatch.elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    minutes.value =
        _stopwatch.elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    hours.value =
        _stopwatch.elapsed.inHours.remainder(24).toString().padLeft(2, '0');
    days.value = _stopwatch.elapsed.inDays.toString().padLeft(1, '0');
  }

  void tripUI(int view) {
    currentWidget.value = view;
  }

  void _getLocationUpdates() {
    _location.listenForLocationUpdates().listen((LocationData locationData) {
      _trips.addLocation(
          _tripId, _trips.createLocationInfo(location: locationData));
    });
  }

  void showPleaseWaitDialog() {
    Get.dialog(
      const ProgressDialog(status: 'Please Wait'),
      barrierDismissible: false,
    );
  }
}
