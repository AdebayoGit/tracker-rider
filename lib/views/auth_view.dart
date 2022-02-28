import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rider/components/auth_components.dart';
import 'package:rider/services/validator.dart';
import 'package:rider/viewmodels/user_vm.dart';
import 'package:rider/views/register_device_view.dart';
import 'package:rider/models/status.dart';
import 'home.dart';

class AuthView extends StatefulWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  late Size _size;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
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
          child: Stack(
            children: [
              Padding(
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
                          Card(
                            elevation: 5,
                            margin: EdgeInsets.zero,
                            child: GestureDetector(
                              onTap: () async {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return const SignIn();
                                  },
                                );
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
                  child: Row(
                    children: const [
                      Text('Register Truck'),
                      Icon(Icons.local_shipping)
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

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _loading = false;

  final TextEditingController _username = TextEditingController();

  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

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
                decoration: const InputDecoration(
                    label: Text('Username'),
                    hintText: 'TruckMan',
                    prefixIcon: Icon(Icons.person)),
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
              child: !_loading
                  ? ElevatedButton(
                      onPressed: () {
                        signIn();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        maximumSize: Size(_size.width * 0.8, 50),
                        primary: Colors.grey,
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
                    )
                  : const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  signIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _loading = true;
    });
    if (_username.text.isNotEmpty & _password.text.isNotEmpty) {
      Object response = await Provider.of<UserViewModel>(context, listen: false)
          .signIn(_username.text, _password.text);
      if (response is Error) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: response.message as String);
      } else {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeView(),
          ),
        );
      }
    } else {
      Fluttertoast.showToast(msg: 'Please fill all field correctly!');
    }
    setState(() {
      _loading = false;
    });
  }
}

/*class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController name = TextEditingController();

  final TextEditingController username = TextEditingController();

  final TextEditingController password = TextEditingController();

  final TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          color: Colors.black,
          child: ConstrainedBox(
            child: Image.asset('./assets/images/truck_cartoon.png',
                fit: BoxFit.contain),
            constraints: const BoxConstraints(
              maxHeight: 180,
              minWidth: double.infinity,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: TextFormField(
            controller: name,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                label: Text('Full Name'),
                hintText: 'John Doe',
                prefixIcon: Icon(Icons.person)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: TextFormField(
            controller: username,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                label: Text('Username'),
                hintText: 'TruckMan',
                prefixIcon: Icon(Icons.account_circle)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: PassTextField(
              validator: Validator.passwordValidator,
              controller: password,
              field: 'Password',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: PassTextField(
              validator: Validator.passwordValidator,
              controller: confirmPassword,
              field: 'Confirm Password'),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () async {
              if (name.text.isNotEmpty & username.text.isNotEmpty & password.text.isNotEmpty) {
                Object response = await Provider.of<UserViewModel>(context, listen: false)
                    .signUp(name.text, username.text, password.text);
                if (response is Error) {
                  ScaffoldMessenger.of(context).showMaterialBanner(
                      MaterialBanner(
                      content: const Text(
                          'Unable to complete registration, please try again!'),
                      actions: [
                        IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .clearMaterialBanners();
                            },
                            icon: const Icon(Icons.clear, color: Colors.red))
                      ]));
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeView(),
                    ),
                  );
                }
              } else {
                Fluttertoast.showToast(
                    msg: 'Please fill all field correctly!');
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              maximumSize: Size(_size.width * 0.8, 50),
              primary: Colors.grey,
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
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}*/
