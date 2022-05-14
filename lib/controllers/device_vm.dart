/*
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rider/services/camera_services.dart';

import '../models/status.dart';

class DeviceViewModel extends ChangeNotifier{

  static DeviceViewModel? _instance;

  DeviceViewModel._(){

  }

  static DeviceViewModel get instance => _instance ??= DeviceViewModel._();

  bool _loading = false;

  late CameraServices camService;

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

  startCamera(){
    setLoading(true);

    setLoading(false);
  }



}*/
