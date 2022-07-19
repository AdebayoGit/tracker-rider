import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rider/utils/trip_constants.dart';

import '../../../components/comments_dialog.dart';
import '../../../controllers/trip_controller.dart';

class TripControlComponents extends GetResponsiveView<TripController> {
  TripControlComponents({Key? key}) : super(key: key) {
    Get.lazyPut(() => TripController());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int value = controller.currentWidget.value;
      return Center(
        child: IconButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return TripRemarksDialog();
              },
            );
          },
          iconSize: 100,
          constraints: BoxConstraints(
            minHeight: Get.height * 0.3,
            minWidth: Get.width * 0.5,
          ),
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(TripConstants.icons[value], color: Colors.transparent.withOpacity(0.7),),
              FittedBox(
                child: Text(
                  TripConstants.actions[value],
                  style: GoogleFonts.dancingScript(
                    textStyle: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
