/*
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:rider/models/status.dart';
import 'package:rider/services/device_services.dart';

class CameraServices {

  CameraController? controller;
  XFile? videoFile;
  bool enableAudio = true;
  List<CameraDescription> cameras = <CameraDescription>[];
  final FirebaseStorage storage = FirebaseStorage.instance;

  CameraServices(this.controller);

  Future<Object> onNewCameraSelected() async {
    if (controller != null) {
      await controller!.dispose();
    }

    final CameraController cameraController = CameraController(
      cameras[1],
      ResolutionPreset.low,
      enableAudio: enableAudio,
    );
    controller = cameraController;

    try {
      await cameraController.initialize();
      return Success(response: "Camera Initialized");
    } on CameraException catch (e) {
      return Failure(code: e.code, errorResponse: e.description as String);
    }
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if ((cameraController?.value.isRecordingVideo)!) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController!.startVideoRecording();
    } on CameraException catch (e) {
      //_showCameraException(e);
      return;
    }
  }

  Future<String?> stopVideoRecording() async {
    final CameraController? _cameraController = controller;

    if (_cameraController == null || !_cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      final video = await _cameraController.stopVideoRecording();
      await GallerySaver.saveVideo(video.path);
      String url = await uploadVideo(video);
      File(video.path).deleteSync();
      return url;
    } on CameraException catch (e) {
      //_showCameraException(e);
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.pauseVideoRecording();
    } on CameraException catch (e) {
      //_showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.resumeVideoRecording();
    } on CameraException catch (e) {
      //_showCameraException(e);
      rethrow;
    }
  }

  Future<void> getAvailableCameras() async {
    try {
      cameras = await availableCameras();
      onNewCameraSelected();
    } on CameraException catch (e) {
      Failure(code: e.code, errorResponse: e.description as String);
    }
  }

  Future<String> uploadVideo(XFile video) async {
    String? username = await DeviceServices.instance.getUsername();
    Reference ref = storage.ref().child('trips/$username');
      await ref.putFile(File(video.path));
      String url = await ref.getDownloadURL();
      return url;
    }
  }*/
