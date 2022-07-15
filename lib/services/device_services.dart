import 'package:shared_preferences/shared_preferences.dart';

import '../models/status.dart';

class DeviceServices {
  static DeviceServices? _instance;

  DeviceServices._();

  static DeviceServices get instance => _instance ??= DeviceServices._();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static const String _firstRunSettingsKey = 'is_first_run';
  static const String _username = 'username';
  static const String _dateAssigned = 'dateVehicleAssigned';
  static const String _driversList = 'usernameList';

  static bool? _isFirstRun;
  static bool? _isRegistered;

  Future<bool> isAppFirstRun() async {
    if (_isFirstRun != null) {
      return _isFirstRun!;
    } else {
      final SharedPreferences prefs = await _prefs;
      bool isFirstRun;
      try {
        isFirstRun = prefs.getBool(_firstRunSettingsKey) ?? true;
      } on Exception {
        isFirstRun = true;
      }
      await prefs.setBool(_firstRunSettingsKey, false);
      _isFirstRun ??= isFirstRun;
      return isFirstRun;
    }
  }

  Future<void> resetFirstRun() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove(_firstRunSettingsKey);
  }

  Future<Status> addDriverToDevice(String username) async {
    final SharedPreferences prefs = await _prefs;
    final String currentTime = DateTime.now().toString();
    try {
      prefs.setString(_username, username);
      prefs.setString(_dateAssigned, currentTime);
      final List<String> drivers = prefs.getStringList(_driversList) ?? [];
      drivers.add(username + currentTime);
      prefs.setStringList(_driversList, drivers);
      return Success(response: "Completed Successfully");
    } on Exception {
      return Failure(code: "Error", response: "Failed to complete");
    }
  }

  Future<void> removeDriverFromDevice() async{
    final SharedPreferences prefs = await _prefs;
    prefs.remove(_username);
    prefs.remove(_dateAssigned);
  }

  Future<bool> isRegistered() async {
    if (_isRegistered != null) {
      return _isRegistered!;
    } else {
      final SharedPreferences prefs = await _prefs;
      bool isRegistered;
      try {
        isRegistered = prefs.getBool('registered') ?? false;
      } on Exception {
        isRegistered = false;
      }
      await prefs.setBool(_firstRunSettingsKey, false);
      _isRegistered ??= isRegistered;
      return isRegistered;
    }
  }

  Future<Status> registerVehicle(String model, int year, String numberPlates, String vehicleId) async {
    final SharedPreferences prefs = await _prefs;
    final String currentTime = DateTime.now().toString();
    try {
      prefs.setString('model', model);
      prefs.setInt('year', year);
      prefs.setString('numberPlates', numberPlates);
      prefs.setString('vehicleId', vehicleId);
      prefs.setString('vehicleRegDate', currentTime);
      prefs.setBool('registered', true);
      return Success(response: "Completed Successfully");
    } on Exception {
      return Failure(code: "Error", response: "Failed to complete");
    }
  }

  Future<String> getVehicleId() async {
    final SharedPreferences prefs = await _prefs;
    String vehicleId = prefs.getString('vehicleId') ?? '';
    return vehicleId;
  }

  Future<String?> getUsername () async {
    final SharedPreferences prefs = await _prefs;
    String? username = prefs.getString(_username);
    return username;
  }
}
