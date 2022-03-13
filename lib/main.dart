import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider/providers/location_vm.dart';
import 'package:rider/providers/user_vm.dart';
import 'package:rider/size_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserViewModel>(create: (_) => UserViewModel()),
        ChangeNotifierProvider<LocationViewModel>(
            create: (_) => LocationViewModel()),

        /// ChangeNotifierProvider<DeviceViewModel>(create: (_) => DeviceViewModel.instance),
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
      title: 'Passenger',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Consumer<UserViewModel>(
        builder: (context, user, child) {
          SizeConfig().init(context);
          user.getInitView();
          return user.initView;
        },
      ),
    );
  }
}
