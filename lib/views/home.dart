import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rider/components/function_icons.dart';
import 'package:rider/viewmodels/app_vm.dart';
import 'package:rider/viewmodels/user_vm.dart';

import '../speed_widget.dart';
import '../viewmodels/app_vm.dart';
import 'auth_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(
          'Home',
          style: GoogleFonts.lato(
              letterSpacing: 5,
              fontWeight: FontWeight.w900,
              color: Colors.white),
        ),
        centerTitle: true,
        titleSpacing: 5,
        actions: [
          Consumer<UserViewModel>(builder: (context, signOut, child) {
            return IconButton(
              onPressed: () async {
                await signOut.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthView(),
                  ),
                );
              },
              icon: const Icon(
                Icons.power_settings_new,
                color: Colors.red,
              ),
            );
          }),
        ],
      ),
      body: Consumer<AppViewModel>(builder: (context, appViewModel, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*Speedometer(
              size: 300,
              minValue: 0,
              maxValue: 180,
              currentValue: (appViewModel.currentLocation.speed ?? 0) ~/ 1000,
              warningValue: 90,
              //backgroundColor: Colors.black,
              meterColor: Colors.green,
              warningColor: Colors.orange,
              kimColor: Colors.red,
              displayNumericStyle: const TextStyle(
                  fontFamily: 'Digital-Display',
                  color: Colors.black,
                  fontSize: 40),
              displayText: 'km/h',
              displayTextStyle: const TextStyle(color: Colors.black, fontSize: 15),
            ),*/
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FittedBox(
                      child: Text(
                        'CURRENT LOCATION',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          child: RichText(
                            text: TextSpan(
                              text: 'Latitude: ',
                              children: [
                                TextSpan(
                                  text: appViewModel.currentLocation.latitude
                                      ?.toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        FittedBox(
                          child: RichText(
                            text: TextSpan(
                              text: 'Longitude: ',
                              children: [
                                TextSpan(
                                  text: appViewModel.currentLocation.longitude
                                      ?.toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    FittedBox(
                      child: RichText(
                        text: TextSpan(
                          text: 'Direction: ',
                          children: [
                            TextSpan(
                              text: appViewModel.currentLocation.heading
                                  ?.toStringAsFixed(2),
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            )
                          ],
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            /*Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
              ),
              child: const Text(
                'ODOMETER',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
              ),
              child: TextFormField(
                controller: odometerController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(hintText: '0.0'),
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 50),*/
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
              ),
              child: TextFormField(
                controller: remarksController,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.start,
                minLines: 3,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Remarks...'),
                style: const TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 50),
            OutlinedButton(
              onPressed: () {
                appViewModel.getLocationUpdates();
              },
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  side: const BorderSide(color: Colors.green)),
              child: const Text(
                'START TRIP',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            CustomAnimatedIcon(
              iconSrc: '',
              press: () {},
            ),
          ],
        );
      }),
    );
  }
}
