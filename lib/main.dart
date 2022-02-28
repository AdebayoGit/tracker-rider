import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider/services/location_services.dart';
import 'package:rider/speed_widget.dart';
import 'package:rider/viewmodels/app_vm.dart';
import 'package:rider/viewmodels/device_vm.dart';
import 'package:rider/viewmodels/user_vm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocationServices().getLocationPermission();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserViewModel>(create: (_) => UserViewModel()),
        ChangeNotifierProvider<AppViewModel>(create: (_) => AppViewModel.instance),
        ChangeNotifierProvider<DeviceViewModel>(create: (_) => DeviceViewModel.instance),
      ],
      child: const Passenger(),
    ),
  );
}


class Passenger extends StatelessWidget {
  const Passenger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, user, child){
        user.getInitView();
        return MaterialApp(
          title: 'Passenger',
          theme: ThemeData(
            primarySwatch: Colors.grey,
          ),
          home: user.initView,
        );
      },
    );
  }
}
