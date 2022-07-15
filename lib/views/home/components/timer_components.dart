import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/trip_controller.dart';

class TimerComponents extends GetResponsiveView<TripController> {
  TimerComponents({Key? key}) : super(key: key) {
    Get.lazyPut(() => TripController());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            style: const TextStyle(
              fontSize: 60,
              fontFamily: 'DIGITAL-7',
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text: controller.days.value,
              ),
              const TextSpan(
                text: ':',
              ),
              TextSpan(
                text: controller.hours.value,
              ),
              const TextSpan(
                text: ':',
              ),
              TextSpan(
                text: controller.minutes.value,
              ),
              const TextSpan(
                text: ':',
              ),
              TextSpan(
                text: controller.seconds.value,
              )
            ]),
      ),
    );
  }
}
