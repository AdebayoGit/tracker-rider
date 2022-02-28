import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rider/components/backgroud_widget.dart';
import 'package:rider/models/status.dart';
import 'package:rider/services/device_services.dart';

import 'auth_view.dart';

class RegisterDevice extends StatefulWidget {
  const RegisterDevice({Key? key}) : super(key: key);

  @override
  State<RegisterDevice> createState() => _RegisterDeviceState();
}

class _RegisterDeviceState extends State<RegisterDevice> {

  final TextEditingController model = TextEditingController();
  final TextEditingController year = TextEditingController();
  final TextEditingController numberPlates = TextEditingController();
  final TextEditingController vehicleId = TextEditingController();

  late Size _size;
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BackGround(
        image: './assets/images/gas truck.jpg',
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
                    'SETUP NEW DEVICE',
                    style: GoogleFonts.abel(
                        textStyle: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(color: Colors.black)),
                  ),
                ),
                Text(
                  '''Providing your name links you to this device. If you wish to change this in the future you must first log out...''',
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
                        elevation: 15,
                        margin: EdgeInsets.zero,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return registrationForm();
                              },
                            );
                          },
                          child: Image.asset(
                            'assets/images/ballooning.png',
                          ),
                        ),
                      )
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

  Padding registrationForm() {
    return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          child: Image.asset('./assets/images/trucks.jpg'),
          //height: 200,
        ),
        _fields(controller: model, label: 'Make/Model', hint: 'Benz G600s', icon: Icons.local_shipping),
        _fields(controller: year, label: 'Year', hint: '2022', icon: Icons.event, type: TextInputType.number),
        _fields(controller: numberPlates, label: 'Number Plates', hint: 'KJA123-Y6F', icon: Icons.tag),
        _fields(controller: vehicleId, label: 'Vehicle ID', hint: 'TRF-1234t', icon: Icons.check_circle_outline),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () async {
              if(model.text.isNotEmpty & year.text.isNotEmpty & numberPlates.text.isNotEmpty & vehicleId.text.isNotEmpty){
                Object response = await DeviceServices.instance.registerVehicle(model.text, int.parse(year.text), numberPlates.text, vehicleId.text);
                if(response is Success){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthView(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(content: const Text('Unable to complete registration, please try again!'), actions: [IconButton(onPressed: (){
                    ScaffoldMessenger.of(context).clearMaterialBanners();
                  }, icon: const Icon(Icons.clear, color: Colors.red))]));
                }
              } else {
                Fluttertoast.showToast(msg: 'Please fill all field correctly!');
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)
              ),
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
                  style: TextStyle(fontSize: 20, letterSpacing: 3, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Padding _fields(
      {required TextEditingController controller,
      required String label,
      required String hint,
      required IconData icon,
        TextInputType? type,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextFormField(
          controller: controller,
          keyboardType: type ?? TextInputType.text,
          decoration: InputDecoration(
              label: Text(label),
              hintText: hint,
              prefixIcon: Icon(icon)),
      ),
    );
  }
}
