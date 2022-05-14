import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rider/components/auth_components.dart';
import 'package:rider/controllers/auth_controller.dart';
import 'package:rider/views/register_device_view.dart';
import '../utils/validator.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: Get.height,
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
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: Get.width * 0.05,
                    right: Get.width * 0.3,
                    top: Get.height * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title text
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
                    /// Subtitle Text
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
                    /// Body Text
                    Text(
                      '''Monitoring trips has never been easier with the passenger app you can share your trip routes without doing too much...''',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.abel(
                          textStyle: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: Colors.black)),
                    ),
                    /// Proceed Button
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
                          Card(
                            elevation: 5,
                            margin: EdgeInsets.zero,
                            child: GestureDetector(
                              onTap: () {
                                Get.bottomSheet(SignIn(), backgroundColor: Colors.white);
                              },
                              child: Image.asset(
                                'assets/images/auth_button.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              /// Register Truck Button
              Positioned(
                top: 0,
                right: 0,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterDevice(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                      color: Colors.grey[900],
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Register Truck',
                        style: TextStyle(
                          color: Colors.grey[900],
                        ),
                      ),
                      Icon(
                        Icons.local_shipping,
                        color: Colors.grey[900],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignIn extends GetResponsiveView<AuthController> {
  SignIn({Key? key}) : super(key: key);

  final TextEditingController _username = TextEditingController();

  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              child: Image.asset('./assets/images/trucks.jpg'),
              //height: 200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                controller: _username,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    label: Text(
                        'Username',
                      style: TextStyle(
                        color: Colors.grey[900],
                      ),
                    ),
                    hintText: 'TruckMan',
                    prefixIcon: Icon(Icons.person, color: Colors.grey[900],),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[900]!)
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: PassTextField(
                  validator: Validator.passwordValidator,
                  controller: _password,
                  field: 'Password'),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: ElevatedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        controller.signIn(_username.text, _password.text);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        maximumSize: Size(Get.width * 0.8, 50),
                        primary: Colors.grey[900],
                        textStyle: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      child: const SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            'Proceed',
                            style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}