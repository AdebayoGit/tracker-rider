import 'package:flutter/material.dart';
import '../utils/app_theme.dart';


class SignOutDialog extends StatelessWidget {
  const SignOutDialog({required this.yes, required this.no, Key? key}) : super(key: key);

  final VoidCallback yes;
  final VoidCallback no;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.logout_sharp, color: AppTheme.primaryColor),
              SizedBox(width: 20),
              Expanded(child: Text('Sign Out')),
            ],
          ),
          const Divider(
            thickness: 2.5,
          ),
        ],
      ),
      content:
      const Text('Are you sure you wish to Sign Out ?'),
      actions: <Widget>[
        TextButton(
          onPressed: yes,
          child: const Text(
            'Yes',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        TextButton(
          onPressed: no,
          child: const Text(
            'No',
            style: TextStyle(
              color: AppTheme.colorGreen,
            ),
          ),
        ),
      ],
    );
  }
}
