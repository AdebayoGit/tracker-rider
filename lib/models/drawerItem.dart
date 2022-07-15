import 'package:flutter/material.dart';

enum DrawerIndex {home, records, about, help, riders}

class DrawerItem {
  DrawerItem({
    this.isAssetsImage = false,
    this.labelName = '',
    required this.icon,
    required this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}


List<DrawerItem> setDrawerItemArray() {
  return <DrawerItem>[
    DrawerItem(
      index: DrawerIndex.home,
      labelName: 'Home',
      icon: const Icon(Icons.home_outlined),
    ),
    DrawerItem(
      index: DrawerIndex.riders,
      labelName: 'Riders',
      icon: const Icon(Icons.sports_motorsports_outlined),
    ),
    DrawerItem(
      index: DrawerIndex.records,
      labelName: 'Records',
      icon: const Icon(Icons.receipt_long_outlined),
    ),
    DrawerItem(
      index: DrawerIndex.help,
      labelName: 'Help',
      icon: const Icon(Icons.support_agent_outlined),
    ),
    DrawerItem(
      index: DrawerIndex.about,
      labelName: 'About',
      icon: const Icon(Icons.app_registration),
    ),
  ];
}