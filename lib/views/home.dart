import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rider/providers/location_vm.dart';
import 'package:rider/providers/user_vm.dart';
import 'package:rider/size_config.dart';

import '../components/comments_dialog.dart';
import '../components/timer_components/minutesTenth.dart';
import '../components/timer_components/minutesUnit.dart';
import '../components/timer_components/secondsTenth.dart';
import '../components/timer_components/secondsUnit.dart';
import '../providers/location_vm.dart';
import 'auth_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  final TextEditingController remarks = TextEditingController();
  /*late final CameraServices camService;

  CameraController? controller;*/

  late AnimationController _animationController;

  late Widget currentWidget = playWidget();

  bool isPlaying = false;
  Color accentColor = Colors.greenAccent;

  final Size _size = SizeConfig.size;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    /*camService = CameraServices(controller);
    camService.getAvailableCameras();*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: isPlaying,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              currentWidget = playWidget();
              isPlaying = false;
            });
          },
          backgroundColor: Colors.black45,
          child: const Icon(Icons.stop, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Consumer<LocationViewModel>(
            builder: (context, LocationViewModel appViewModel, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  PageTransitionSwitcher(
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return FadeThroughTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        child: child,
                      );
                    },
                    child: currentWidget,
                  ),
                  MyHomePage(),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  alignment: Alignment.centerRight,
                  constraints: BoxConstraints(
                    minHeight: _size.height * 0.1,
                    minWidth: _size.width * 0.2,
                  ),
                  onPressed: () async {
                    Provider.of<UserViewModel>(context, listen: false)
                        .signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthView(),
                      ),
                      (_) => false,
                    );
                  },
                  icon: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Expanded(
                        child: Icon(
                          Icons.power_settings_new,
                          color: Colors.red,
                        ),
                      ),
                      Expanded(child: Text('Sign Out')),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _handleOnPressed() async {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying ? _startTrip() : _pauseTrip();
    });
  }

  void _pauseTrip() {
    Provider.of<LocationViewModel>(context, listen: false).pauseTrip();
    _animationController.reverse();
  }

  void _startTrip() {
    _animationController.forward();
    Provider.of<LocationViewModel>(context, listen: false).startTrip();
  }

  /*Column(
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
  Container(
  margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
  padding: const EdgeInsets.symmetric(horizontal: 20),
  decoration: BoxDecoration(
  border: Border.all(color: Colors.black45),
  ),
  child: TextFormField(
  controller: remarks,
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
  Row(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
  Container(
  margin: const EdgeInsets.symmetric(horizontal: 10),
  decoration: BoxDecoration(
  border: Border.all(
  width: 2,
  ),
  shape: BoxShape.circle,
  ),
  child: IconButton(
  iconSize: 30,
  splashColor: accentColor,
  icon: AnimatedIcon(
  icon: AnimatedIcons.play_pause,
  progress: _animationController,
  ),
  onPressed: () async {
  showDialog(context: context, builder: (_){
  return const AlertDialog();
  });
  await appViewModel.startTrip(remarks.text);
  Navigator.pop(context);
  _handleOnPressed();
},
),
),
Container(
margin: const EdgeInsets.symmetric(horizontal: 10),
decoration: BoxDecoration(
border: Border.all(
width: 2,
),
shape: BoxShape.circle,
),
child: IconButton(
iconSize: 30,
splashColor: accentColor,
icon: const Icon(
Icons.stop,
),
onPressed: () async {
setState(() {
isPlaying = false;
});
},
),
),
],
),
],
);*/

  Widget playWidget() => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: _size.width * 0.05,
              right: _size.width * 0.3,
              top: _size.height * 0.1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(
                    'READY ?',
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
                    'GET STARTED',
                    style: GoogleFonts.abel(
                        textStyle: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(color: Colors.black)),
                  ),
                ),
                Text(
                  '''You can start a new trip by tapping on the play button below, enter your comments into the pop-up and proceed on your trip...''',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.abel(
                      textStyle: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.black)),
                ),
              ],
            ),
          ),
          Center(
            child: IconButton(
              onPressed: () async {
                setState(() {
                  currentWidget = pauseWidget();
                  isPlaying = true;
                });
                /*await showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return const CommentDialog();
              },
            );*/
              },
              iconSize: 100,
              constraints: BoxConstraints(
                minHeight: _size.height * 0.3,
                minWidth: _size.width * 0.5,
              ),
              icon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow),
                  FittedBox(
                    child: Text(
                      'Start...',
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
          ),
        ],
      );

  Widget pauseWidget() => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: _size.width * 0.05,
              right: _size.width * 0.3,
              top: _size.height * 0.1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(
                    'PAUSE ?',
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
                    'TAKE A BREAK',
                    style: GoogleFonts.abel(
                        textStyle: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(color: Colors.black)),
                  ),
                ),
                Text(
                  '''You can pause a trip by tapping on the pause button below, enter your comments into the pop-up and your trip will be paused...''',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.abel(
                      textStyle: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.black)),
                ),
              ],
            ),
          ),
          Center(
            child: IconButton(
              onPressed: () async {
                setState(() {
                  currentWidget = resumeWidget();
                });
                /*await showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return const CommentDialog();
              },
            );*/
              },
              iconSize: 100,
              constraints: BoxConstraints(
                minHeight: _size.height * 0.3,
                minWidth: _size.width * 0.5,
              ),
              icon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.pause),
                  FittedBox(
                    child: Text(
                      'Pause...',
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
          ),
        ],
      );

  Widget resumeWidget() => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: _size.width * 0.05,
              right: _size.width * 0.3,
              top: _size.height * 0.1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(
                    'RESUME ?',
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
                    'CONTINUE TRIP',
                    style: GoogleFonts.abel(
                        textStyle: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(color: Colors.black)),
                  ),
                ),
                Text(
                  '''You can pause a trip by tapping on the pause button below, enter your comments into the pop-up and your trip will be paused...''',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.abel(
                      textStyle: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.black)),
                ),
              ],
            ),
          ),
          Center(
            child: IconButton(
              onPressed: () async {
                setState(() {
                  currentWidget = pauseWidget();
                });
                /*await showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return const CommentDialog();
              },
            );*/
              },
              iconSize: 100,
              constraints: BoxConstraints(
                minHeight: _size.height * 0.3,
                minWidth: _size.width * 0.5,
              ),
              icon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.replay),
                  FittedBox(
                    child: Text(
                      'Resume...',
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
          ),
        ],
      );
}



class MyHomePage extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Duration _duration = new Duration(seconds: (10));

  int _counter = 4200;
  late Timer _timer;
  int minuteTenth = 0, minuteUnit = 0, secondTenth = 0, secondUnit = 0;

  String showtime = "120 Seconds Countdown";
  bool _isbuttondisabled = false;
  void startTimer() {
    _counter = (4200);

    _timer = Timer.periodic(
      Duration(seconds: 1),
          (timer) {
        if (_counter > 0) {
          setState(() {
            _isbuttondisabled = true;
            _counter--;
            _duration = new Duration(seconds: _counter);
            showtime = "${_duration.inMinutes}:${_duration.inSeconds % 60}";
            print(showtime);
            minuteTenth = ((_duration.inMinutes) / 10).floor();
            minuteUnit = ((_duration.inMinutes) % 10).round();
            secondTenth = ((_duration.inSeconds % 60) / 10).floor();
            secondUnit = ((_duration.inSeconds % 60) % 10).round();
          });
        } else {
          _timer.cancel();
          setState(() {
            _isbuttondisabled = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: MyMinuteUnit(minuteTenth)),
                Expanded(child: MyMinuteUnit(minuteUnit)),
                const SizedBox(
                  height: 150,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      ":",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(child: MyMinuteUnit(secondTenth)),
                Expanded(child: MyMinuteUnit(secondUnit)),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  elevation: 10,
                  onPressed: _isbuttondisabled == false ? startTimer : null,
                  child: Text("Start Timer"),
                ),
                RaisedButton(
                  elevation: 10,
                  onPressed: _isbuttondisabled == true ? setcounterZero : null,
                  child: Text("Stop Timer"),
                ),
              ],
            ),
          ),
        ],
      );
  }

  setcounterZero() {
    setState(() {
      _counter = 0;
    });
    minuteTenth = 0;
    minuteUnit = 0;
    secondTenth = 0;
    secondUnit = 0;
  }
}
