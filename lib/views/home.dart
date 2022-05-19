import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rider/components/trip_components/control_widget.dart';
import 'package:rider/controllers/auth_controller.dart';
import 'package:rider/controllers/trip_controller.dart';
import 'package:rider/utils/trip_constants.dart';


class HomeView extends GetResponsiveView<TripController> {
  HomeView({Key? key}) : super(key: key){
    Get.lazyPut(() => TripController());
    _auth = Get.put(AuthController());
  }

  late final AuthController _auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(() {
          return Visibility(
            visible: controller.currentWidget.value != 0,
            child: FloatingActionButton(
              onPressed: controller.stopTrip,
              backgroundColor: Colors.black45,
              child: const Icon(Icons.stop, color: Colors.white),
            ),
          );
        }
      ),
      body: Container(
        width: double.infinity,
        height: Get.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/background.png',
            ),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.color),
          ),
        ),
        child: SafeArea(
          child: Stack(
              //fit: StackFit.expand,
              children: [
                Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: PageTransitionSwitcher(
                        duration: const Duration(seconds: 1),
                        transitionBuilder: (
                          Widget child,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                        ) {
                          return FadeThroughTransition(
                            animation: animation,
                            secondaryAnimation: secondaryAnimation,
                            child: child,
                          );
                        },
                        child: Obx(() {
                          int value = controller.currentWidget.value;
                            return ControlWidget(
                              title: TripConstants.titles[value],
                              body: TripConstants.body[value],
                              subtitle: TripConstants.subtitles[value],
                              action: TripConstants.actions[value],
                              icon: TripConstants.icons[value],
                              press: () {
                                controller.tripControl();
                              },
                            );
                          }
                        ),
                      ),
                    ),
                  ],
                ),
                /// Timer widget
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Obx(() => RichText(
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
                  ),
                ),
                /// Sign Out widget
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    alignment: Alignment.centerRight,
                    constraints: BoxConstraints(
                      minHeight: Get.height * 0.1,
                      minWidth: Get.width * 0.2,
                    ),
                    onPressed: () async {
                      _auth.signOut();
                    },
                    icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Expanded(
                          child: Icon(
                            Icons.power_settings_new,
                            color: Colors.red,
                          ),
                        ),
                        Expanded(child: Text('Sign Out')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }

}
