import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rider/controllers/location_controller.dart';
import 'package:rider/helpers/presence.dart';
import 'package:rider/services/device_services.dart';
import 'package:rider/views/register_device_view.dart';
import 'package:rider/views/splash_view.dart';

import 'controllers/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const Passenger(),
  );
}

class Passenger extends StatelessWidget {
  const Passenger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: const SplashView(),
        onInit: () async {
          bool _isRegistered = await DeviceServices.instance.isRegistered();
          if (!_isRegistered) {
            Get.offAll(
              () => const RegisterDevice(),
              transition: Transition.fadeIn,
              duration: const Duration(seconds: 1),
            );
          } else {
            Get.put(AuthController());
          }
        }
        //onDispose: ,
        );
  }
}
