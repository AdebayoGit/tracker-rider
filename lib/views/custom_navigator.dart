import 'package:flutter/material.dart';

import '../components/custom_drawer/drawer_controller.dart';
import '../models/drawerItem.dart';
import '../utils/app_theme.dart';
import 'home/body.dart';

class CustomNavigator extends StatefulWidget {
  const CustomNavigator({Key? key}) : super(key: key);

  static const String id = 'navigator';

  @override
  CustomNavigatorState createState() => CustomNavigatorState();
}

class CustomNavigatorState extends State<CustomNavigator> {
  late Widget screenView;
  late DrawerIndex drawerIndex;
  late bool home;
  late Color color;


  @override
  void initState() {
    drawerIndex = DrawerIndex.home;
    home = false;
    screenView = HomeView();
    color = AppTheme.nearlyWhite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DrawerUserController(
        color: color,
        screenIndex: drawerIndex,
        drawerWidth: MediaQuery.of(context).size.width * 0.75,
        onDrawerCall: (DrawerIndex drawerIndexdata) {
          changeIndex(drawerIndexdata);
          //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
        },
        screenView: screenView,
        // ignore: avoid_types_as_parameter_names
        drawerIsOpen: (bool ) {  },
        //We replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.home) {
        setState(() {
          screenView = HomeView();
          color = AppTheme.nearlyBlack;
        });
      } else if (drawerIndex == DrawerIndex.riders){
        setState(() {
          screenView = Container();
          color = AppTheme.nearlyBlack;
        });
      } else if (drawerIndex == DrawerIndex.records){
        setState(() {
          screenView = Container();
          color = AppTheme.nearlyBlack;
        });
      } else if (drawerIndex == DrawerIndex.about){
        setState(() {
          screenView = Container();
          color = AppTheme.nearlyWhite;
        });
      } else if (drawerIndex == DrawerIndex.help){
        setState(() {
          screenView = Container();
          color = AppTheme.nearlyBlack;
        });
      } else {
        //do in your way......
      }
    }
  }
}
