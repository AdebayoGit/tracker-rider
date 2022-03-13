import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rider/components/timer_components/timer_led.dart';

class MySecondsUnit extends StatefulWidget {
  final int digit;

  const MySecondsUnit(this.digit, {Key? key}) : super(key: key);

  @override
  MySecondsUnitState createState() => MySecondsUnitState();
}

class MySecondsUnitState extends State<MySecondsUnit> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color:
              myTime[widget.digit][0] == 1 ? Colors.black : Colors.white,
          height: 2.5,
          width: 50,
        ),
        Transform.translate(
          offset: const Offset(30, 30),
          child: Transform.rotate(
            angle: pi / 2,
            child: Container(
              color: myTime[widget.digit][1] == 1
                  ? Colors.black
                  : Colors.white,
              height: 2.5,
              width: 50,
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, 57),
          child: Container(
            color: myTime[widget.digit][2] == 1
                ? Colors.black
                : Colors.white,
            height: 2.5,
            width: 50,
          ),
        ),
        Transform.translate(
          offset: const Offset(30, 85),
          child: Transform.rotate(
            angle: pi / 2,
            child: Container(
              color: myTime[widget.digit][3] == 1
                  ? Colors.black
                  : Colors.white,
              height: 2.5,
              width: 50,
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, 115),
          child: Container(
            color: myTime[widget.digit][4] == 1
                ? Colors.black
                : Colors.white,
            height: 2.5,
            width: 50,
          ),
        ),
        Transform.translate(
          offset: const Offset(-30, 85),
          child: Transform.rotate(
            angle: pi / 2,
            child: Container(
              color: myTime[widget.digit][5] == 1
                  ? Colors.black
                  : Colors.white,
              height: 2.5,
              width: 50,
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(-30, 30),
          child: Transform.rotate(
            angle: pi / 2,
            child: Container(
              color: myTime[widget.digit][6] == 1
                  ? Colors.black
                  : Colors.white,
              height: 2.5,
              width: 50,
            ),
          ),
        ),
      ],
    );
  }
}
