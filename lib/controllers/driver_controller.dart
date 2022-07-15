import 'package:get/get.dart';
import 'package:rider/services/driver_services.dart';

import '../helpers/response.dart';
import '../models/driver.dart';
import '../models/status.dart';

class DriverController extends GetxController {
  late final Driver _driver;

  late final DriverServices _services;

  @override
  void onInit() async {
    _services = DriverServices();
    super.onInit();
  }

  String? get driversUsername => _driver.username;

  String get driversPhotoUrl => _driver.photoUrl;

  Future<void> getCurrentDriver(String uid) async {
    Object? response = await _services.getCurrentDriver(uid);
    if (response is Success) {
      _driver = response.response as Driver;
    } else if (response is Failure) {
      ResponseHelpers.showSnackbar(response.response.toString());
    }
  }
}
