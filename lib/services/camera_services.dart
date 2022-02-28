import 'dart:io';

import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:rider/models/status.dart';

class CameraServices {

  CameraController? controller;
  XFile? videoFile;
  bool enableAudio = true;

  CameraServices(this.controller);

  Future<Object> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
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

  Future<void> stopVideoRecording() async {
    final CameraController? _cameraController = controller;

    if (_cameraController == null || !_cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      final video = await _cameraController.stopVideoRecording();
      await GallerySaver.saveVideo(video.path);
      File(video.path).deleteSync();
    } on CameraException catch (e) {
      //_showCameraException(e);
      return;
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
}