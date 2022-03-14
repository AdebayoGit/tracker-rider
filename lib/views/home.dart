import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rider/providers/location_vm.dart';
import 'package:rider/providers/user_vm.dart';
import 'package:rider/size_config.dart';

import '../providers/location_vm.dart';
import 'auth_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  /*late final CameraServices camService;
  CameraController? controller;
  late AnimationController _animationController;*/

  final TextEditingController remarks = TextEditingController();

  late Widget currentWidget = playWidget();

  bool isPlaying = false;

  Color accentColor = Colors.greenAccent;

  final Size _size = SizeConfig.size;

  Duration _duration = const Duration(seconds: (1));

  int _counter = 0;

  late Timer _timer;

  int day = 0, hourTenth = 0, hourUnit = 0, minuteTenth = 0, minuteUnit = 0, secondTenth = 0, secondUnit = 0;

  /*@override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    camService = CameraServices(controller);
    camService.getAvailableCameras();
    super.initState();
  }*/

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
              _stopTrip();
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
                //mainAxisAlignment: MainAxisAlignment.start,
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
                ],
              ),
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: const TextStyle(
                        fontSize: 60,
                        fontFamily: 'DIGITAL-7',
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '$day',
                        ),
                        const TextSpan(
                          text: ':',
                        ),
                        TextSpan(
                          text: '$hourTenth',
                        ),
                        TextSpan(
                          text: '$hourUnit',
                        ),
                        const TextSpan(
                          text: ':',
                        ),
                        TextSpan(
                          text: '$minuteTenth',
                        ),
                        TextSpan(
                          text: '$minuteUnit',
                        ),
                        const TextSpan(
                          text: ':',
                        ),
                        TextSpan(
                          text: '$secondTenth',
                        ),
                        TextSpan(
                          text: '$secondUnit',
                        ),
                      ]),
                ),
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

  void _pauseTrip() {
    Provider.of<LocationViewModel>(context, listen: false).pauseTrip();
    _timer.cancel();
  }

  void _startTrip() {
    Provider.of<LocationViewModel>(context, listen: false).startTrip();
    _startTimer();
  }

  void _startTimer() {
    //Todo: Change to stopwatch instead
    setState(() {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          _counter++;
          _duration = Duration(seconds: _counter);
          minuteTenth = ((_duration.inMinutes) / 10).floor();
          minuteUnit = ((_duration.inMinutes) % 10).round();
          secondTenth = ((_duration.inSeconds % 60) / 10).floor();
          secondUnit = ((_duration.inSeconds % 60) % 10).round();
        },
      );
    });
  }

  void _stopTrip() {
    Provider.of<LocationViewModel>(context, listen: false).stopTrip(null);
    _resetTimer();
  }

  _resetTimer() {
    setState(() {
      _counter = 0;
      day = 0;
      hourTenth = 0;
      hourUnit = 0;
      minuteTenth = 0;
      minuteUnit = 0;
      secondTenth = 0;
      secondUnit = 0;
    });
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
                  _startTrip();
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
                  _pauseTrip();
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
                  _startTrip();
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
