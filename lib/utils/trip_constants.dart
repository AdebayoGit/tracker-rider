import 'package:flutter/material.dart';

class TripConstants{

  static final TripConstants _instance = TripConstants._();

  TripConstants._();

  factory TripConstants() {
    return _instance;
  }

  static const List<String> actions = <String>['Start...', 'Pause...', 'Resume...'];

  static const List<String> titles = <String>['READY ?', 'PAUSE ?', 'RESUME ?'];

  static const List<String> subtitles = <String>['GET STARTED', 'TAKE A BREAK', 'CONTINUE TRIP'];

  static const List<String> body = <String>[
    '''You can start a new trip by tapping on the play button below, enter your comments into the pop-up and proceed on your trip...''',
    '''You can pause a trip by tapping on the pause button below, enter your comments into the pop-up and your trip will be paused...''',
    '''You can pause a trip by tapping on the pause button below, enter your comments into the pop-up and your trip will be paused...'''
  ];

  static List<IconData> icons = <IconData>[
    Icons.play_arrow,
    Icons.pause,
    Icons.replay,
  ];

}