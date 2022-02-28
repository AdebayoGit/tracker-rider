import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rider/models/rider.dart';
import 'package:rider/services/auth_services.dart';
import 'package:rider/services/camera_services.dart';
import 'package:rider/services/device_services.dart';
import 'package:rider/views/auth_view.dart';
import 'package:rider/views/home.dart';
import 'package:rider/views/register_device_view.dart';
import 'package:rider/views/splash_view.dart';

import '../models/status.dart';

class DeviceViewModel extends ChangeNotifier{

  static DeviceViewModel? _instance;

  DeviceViewModel._();

  static DeviceViewModel get instance => _instance ??= DeviceViewModel._();

  DeviceViewModel() {
    getAvailableCameras();
    camService = CameraServices(controller);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _loading = false;

  bool _isFirstRun = false;

  List<CameraDescription> cameras = <CameraDescription>[];

  late CameraServices camService;


  CameraController? controller;

  bool _isCameraInitialized = false;

  bool get loading => _loading;


  bool get isCameraInitialized => _isCameraInitialized;


  void setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  void setIsCameraInitialized(bool value){
    _isCameraInitialized = value;
    notifyListeners();
  }

  Future<void> getAvailableCameras() async {
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      Failure(code: e.code, errorResponse: e.description as String);
    }
  }

  startCamera(){
    setLoading(true);
    camService.onNewCameraSelected(cameras[1]);
    setLoading(false);
  }



}