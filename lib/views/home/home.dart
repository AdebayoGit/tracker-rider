import 'package:flutter/material.dart';
import 'package:rider/views/home/map_view.dart';

import 'body.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(child: HomeView()),
      ],
    );
  }
}
