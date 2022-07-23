import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_animarker/widgets/animarker.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

import 'package:rider/controllers/trip_controller.dart';
import 'package:rider/views/home/components/text_components.dart';
import 'package:rider/views/home/components/timer_components.dart';

import '../../utils/app_theme.dart';
import 'components/trip_control_components.dart';

class HomeView extends GetResponsiveView<TripController> {
  HomeView({Key? key}) : super(key: key) {
    Get.lazyPut(() => TripController());
  }

  final Completer<GoogleMapController> _completer = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Obx(() {
        return Visibility(
          visible: controller.currentWidget.value != 0,
          child: FloatingActionButton(
            onPressed: controller.stopTrip,
            backgroundColor: Colors.black45,
            child: const Icon(Icons.stop, color: Colors.white),
          ),
        );
      }),
      body: Stack(
        children: [
          /// Google map Widget
          Obx(() {
            return Animarker(
              curve: Curves.ease,
              mapId: _completer.future
                  .then<int>((value) => value.mapId,
              ), //Grab Google Map Id
              markers: controller.markers.values.toSet(),
              rippleColor: AppTheme.primaryLightColor,
              child: GoogleMap(
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
                initialCameraPosition: const CameraPosition(
                  target: LatLng(37.42796133580664, -122.085749655962),
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController googleMapController) async {
                  _completer.complete(googleMapController);
                  await controller.getInitialLocation(googleMapController);
                },
              ),
            );
          }),

          /// Description text
          HomeTextComponent(),

          /// * [Play, Pause, Restart] Operations control buttons
          TripControlComponents(),

          /// Timer widget
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: TimerComponents(),
          ),
        ],
      ),
    );
  }
}
