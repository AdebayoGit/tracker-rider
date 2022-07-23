import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rider/components/auth_components.dart';
import 'package:rider/controllers/auth_controller.dart';
import '../utils/validator.dart';

class AuthView extends GetResponsiveView<AuthController> {
  AuthView({Key? key}) : super(key: key);

  final TextEditingController _username = TextEditingController();

  final TextEditingController _password = TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();

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
              ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: Get.width * 0.05,
                      right: Get.width * 0.3,
                      top: Get.height * 0.1,
                    ),
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

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              FittedBox(
                                child: Text(
                                  'Sign in to proceed...',
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 1.7,
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              'SIGN IN',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                textStyle:
                                Theme.of(context).textTheme.headline3!.copyWith(
                                  fontWeight: FontWeight.w900,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 1
                                    ..color = Colors.grey[600]!,
                                ),
                              ),
                            ),
                            AuthTextField(
                                controller: _username,
                                textInputType: TextInputType.text,
                                label: 'Username',
                                hintText: 'TruckMan',
                                validator: Validator.nameValidator,
                                onSubmitted: (_) {
                                  _passwordFocusNode.requestFocus();
                                },
                                icon: Icons.person,
                            ),
                            PassTextField(
                              validator: Validator.passwordValidator,
                              focusNode: _passwordFocusNode,
                              controller: _password,
                              hint: 'Password',
                              onSubmitted: (_) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                controller.signIn(_username.text, _password.text);
                              },
                            ),
                            Button(
                              title: 'Sign In',
                              press: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                controller.signIn(_username.text, _password.text);
                              },
                              color: Colors.grey[600]!,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                child: Text(
                                  'Forgot Password ?',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: Colors.grey[600]!,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                onPressed: () {
                                  //controller.getForgotPasswordSheet();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
