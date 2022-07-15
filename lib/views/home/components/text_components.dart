import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rider/utils/trip_constants.dart';

import '../../../controllers/trip_controller.dart';

class HomeTextComponent extends GetResponsiveView<TripController> {
  HomeTextComponent({Key? key}) : super(key: key) {
    Get.lazyPut(() => TripController());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int value = controller.currentWidget.value;
      return Padding(
        padding: EdgeInsets.only(
          left: Get.width * 0.05,
          right: Get.width * 0.3,
          top: Get.height * 0.15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: Text(
                TripConstants.titles[value],
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            FittedBox(
              child: Text(
                TripConstants.subtitles[value],
                style: GoogleFonts.abel(
                    textStyle: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: Colors.black)),
              ),
            ),
            Text(
              TripConstants.body[value],
              textAlign: TextAlign.justify,
              style: GoogleFonts.abel(
                  textStyle: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.black)),
            ),
          ],
        ),
      );
    });
  }
}
