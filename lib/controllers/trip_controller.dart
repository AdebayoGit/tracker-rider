import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_animarker/core/ripple_marker.dart';

import 'package:rider/components/progress_dialog.dart';
import 'package:rider/services/location_services.dart';
import 'package:rider/services/trip_services.dart';

import '../main.dart';
import '../models/status.dart';

class TripController extends GetxController {
  final Stopwatch _stopwatch = Stopwatch();

  final RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  static const MarkerId truckMarkerId = MarkerId('Truck Marker');

  BitmapDescriptor? truckIcon;

  final LocationServices _location = LocationServices();

  late StreamSubscription<LocationData> _locationSub;

  late LocationData _currentLocation;

  final TripServices _trips = TripServices();

  final TextEditingController remarks = TextEditingController();

  late GoogleMapController mapController;

  ///Todo: uncomment to handle control of location stream
  // late final StreamSubscription<LocationData> _locationStream;

  late Timer _timer;

  late String _tripId;

  RxString days = '0'.obs,
      hours = '00'.obs,
      minutes = '00'.obs,
      seconds = '00'.obs;

  late RxInt currentWidget = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    createMarker();
    checkLeftOverTrip();
  }

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
    Object response = await _trips.createTrip(_currentLocation, remarks.text);
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
        message: failure.response.toString(),
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

  Future<void> _continueLeftOverTrip() async {
    showPleaseWaitDialog();
    await _location.checkLocationPermission();
    tripUI(1);
    startTimer();
    _getLocationUpdates();
    Get.back(closeOverlays: true);
  }

  Future<void> pauseTrip() async {
    Get.back();
    showPleaseWaitDialog();
    Object response = _trips.pauseTrip(_tripId, remarks.text, _currentLocation);
    remarks.clear();
    if (response is Failure) {
      Failure failure = response;
      Get.back();
      Get.showSnackbar(GetSnackBar(
        title: failure.code,
        message: failure.response.toString(),
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
    _locationSub.cancel();
    Object? response = _trips.stopTrip(_tripId, _currentLocation);
    remarks.clear();
    RootWidget.restartApp(Get.context!);
    if (response != null) {
      Failure failure = response as Failure;
      Get.back();
      Get.showSnackbar(GetSnackBar(
        title: failure.code,
        message: failure.response.toString(),
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

  Future<void> getInitialLocation(GoogleMapController controller) async {
    mapController = controller;

    _currentLocation = await _location.getCurrentLocation();

    _updateMarker(_currentLocation, truckMarkerId);

    await moveMap(_currentLocation);
  }

  Future<void> moveMap(LocationData locationData) async {
    CameraPosition position = CameraPosition(
      bearing: locationData.heading!,
      target: LatLng(locationData.latitude!, locationData.longitude!),
      zoom: 14.4746,
    );

    mapController.animateCamera(CameraUpdate.newCameraPosition(position));
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
    _locationSub = _location
            .listenForLocationUpdates().listen((LocationData locationData) async {
      Map<String, dynamic> locationInfo = _trips.createLocationInfo(location: locationData);
      _currentLocation = locationData;
      _trips.addLocation(_tripId, locationInfo);
      _updateMarker(locationData, truckMarkerId);
      await moveMap(locationData);
    });
  }

  void createMarker() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(Get.context!, size: const Size(2, 2));
    BitmapDescriptor.fromAssetImage(
      imageConfiguration,
      'assets/images/car_android.png',
    ).then((icon) {
      truckIcon = icon;
    });
  }

  void _updateMarker(LocationData locationData, MarkerId markerId) {

    var marker = RippleMarker(
      markerId: markerId,
      position: LatLng(locationData.latitude!, locationData.longitude!),
      rotation: locationData.heading!,
      ripple: true,
      icon: truckIcon,
    );
    markers[markerId] = marker;
  }

  void showPleaseWaitDialog() {
    Get.dialog(
      const ProgressDialog(status: 'Please Wait'),
      barrierDismissible: false,
    );
  }

  Future<void> checkLeftOverTrip() async {
    String? leftOverTripId = await _trips.checkForUncompletedTrips();

    if (leftOverTripId == null) {
      return;
    } else {
      _tripId = leftOverTripId;
      _continueLeftOverTrip();
    }
  }
}
