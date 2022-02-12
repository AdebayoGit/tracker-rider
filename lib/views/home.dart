import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rider/viewmodels/app_vm.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final TextEditingController odometerController = TextEditingController();

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
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.power_settings_new,
                color: Colors.red,
              )),
        ],
      ),
      body: Consumer<AppViewModel>(builder: (context, appViewModel, child) {
        print(appViewModel.currentLocation.speed);
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
              style: OutlinedButton.styleFrom(minimumSize: Size(200, 50), side: BorderSide(color: Colors.green)),
              child: const Text(
                'START TRIP',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
