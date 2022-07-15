import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const DefaultTextStyle(
                  style: TextStyle(
                      fontSize: 50.0,
                      fontFamily: 'Canterbury',
                      color: Colors.black45),
                  child: Text("Passenger"),
                  ),
              const SizedBox(height: 250),
              LinearProgressIndicator(
                color: Colors.blueGrey[900],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
