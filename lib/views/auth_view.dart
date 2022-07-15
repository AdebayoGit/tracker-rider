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
                                Get.bottomSheet(SignIn(),
                                    isScrollControlled: false,
                                    backgroundColor: Colors.white,
                                    enterBottomSheetDuration:
                                        const Duration(milliseconds: 500),
                                    exitBottomSheetDuration:
                                        const Duration(milliseconds: 500));
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
                right: 10,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Register Truck',
                        style: TextStyle(
                          color: Colors.grey[900],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.local_shipping,
                        color: Colors.grey[900],
                      ),
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

  final FocusNode _passwordFocusNode = FocusNode();

  final FocusNode _usernameFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            child: Image.asset('./assets/images/trucks.jpg'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextFormField(
              controller: _username,
              focusNode: _usernameFocusNode,
              keyboardType: TextInputType.text,
              validator: Validator.nameValidator,
              decoration: InputDecoration(
                label: Text(
                  'Username',
                  style: TextStyle(
                    color: Colors.grey[900],
                  ),
                ),
                hintText: 'TruckMan',
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.grey[900],
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[900]!)),
              ),
              onFieldSubmitted: (_) {
                _passwordFocusNode.requestFocus();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: PassTextField(
                validator: Validator.passwordValidator,
                focusNode: _passwordFocusNode,
                controller: _password,
                field: 'Password',
            ),
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
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
