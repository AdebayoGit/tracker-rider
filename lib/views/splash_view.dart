import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rider/viewmodels/app_vm.dart';

import 'home.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppViewModel>(
      builder: (context, appViewModel, child){

        bool? serviceEnabled = appViewModel.locationEnabled;
        if (serviceEnabled != null) {
          if(serviceEnabled){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeView(),
              ),
            );
          } else if (!serviceEnabled){
            Fluttertoast.showToast(
                msg: "Location Service not Enabled",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
        }
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DefaultTextStyle(
                    style: const TextStyle(
                        fontSize: 50.0,
                        fontFamily: 'Canterbury',
                        color: Colors.black45
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        ScaleAnimatedText('Monitor...'),
                        ScaleAnimatedText('See...'),
                        ScaleAnimatedText('Control...'),
                        ScaleAnimatedText(
                            'PASSENGER',
                            textStyle: GoogleFonts.lato(
                                fontWeight: FontWeight.bold
                            ),
                            duration: const Duration(milliseconds: 6000)
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 250),
                  LinearProgressIndicator(
                    color: Colors.blueGrey[900],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
