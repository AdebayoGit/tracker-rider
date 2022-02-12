import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rider/viewmodels/app_vm.dart';
import 'package:rider/viewmodels/user_vm.dart';

import 'home.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: _size.height,
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
          child: Padding(
            padding: EdgeInsets.only(
                left: _size.width * 0.05,
                right: _size.width * 0.3,
                top: _size.height * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(
                    'PASSENGER',
                    style: GoogleFonts.lato(
                        textStyle: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
                FittedBox(
                  child: Text(
                    'TRIP MONITOR',
                    style: GoogleFonts.abel(
                        textStyle: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(color: Colors.black)),
                  ),
                ),
                Text(
                  '''Monitoring trips has never been easier with the passenger app you can share your trip routes without doing too much...''',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.abel(
                      textStyle: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.black)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      FittedBox(
                        child: Text(
                          'Proceed...',
                          style: GoogleFonts.dancingScript(
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 5),
                          ),
                        ),
                      ),
                      Consumer2<UserViewModel, AppViewModel>(
                          builder: (context, userViewModel, appViewModel, child) {
                        return GestureDetector(
                          onTap: () async {
                            await userViewModel.signIn();
                            if (userViewModel.error != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(userViewModel.error!.message
                                          .toString())));
                            } else {
                              await appViewModel.getCurrentLocation();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeView(),
                                ),
                              );
                            }
                          },
                          child: !userViewModel.loading
                              ? Card(
                                  elevation: 5,
                                  margin: EdgeInsets.zero,
                                  child: Image.asset(
                                    'assets/images/auth_button.png',
                                  ),
                                )
                              : const LinearProgressIndicator(),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
