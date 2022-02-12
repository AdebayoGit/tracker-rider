import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider/services/location_services.dart';
import 'package:rider/viewmodels/app_vm.dart';
import 'package:rider/viewmodels/user_vm.dart';
import 'package:rider/views/auth_view.dart';
import 'package:rider/views/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocationServices.getLocationPermission();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserViewModel>(create: (_) => UserViewModel()),
        ChangeNotifierProvider<AppViewModel>(create: (_) => AppViewModel()),
      ],
      child: const Passenger(),
    ),
  );
}

class Passenger extends StatelessWidget {
  const Passenger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const AuthView(),
    );
  }
}
