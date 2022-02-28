import 'package:flutter/material.dart';


class Button extends StatelessWidget {
  final String title;
  final VoidCallback press;
  final Color color, textColor;
  const Button({
    Key? key,
    required this.title,
    required this.press,
    required this.color,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            backgroundColor: color,
          ),
          onPressed: press,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              title,
              style: TextStyle(
                  color: textColor,
                  letterSpacing: 5,
                  wordSpacing: 3,
                  fontSize: 15,
                  fontWeight: FontWeight.w900
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType textInputType;
  final String hintText;
  final validator;
  final IconData icon;


  const AuthTextField({
    Key? key,
    required this.controller,
    required this.textInputType,
    required this.hintText,
    required this.validator,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: textInputType,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            icon,
          ),
          hintText: hintText,
        )
    );
  }
}


class PassTextField extends StatefulWidget {
  final String?Function(String?)? validator;
  final TextEditingController controller;
  final String field;

  const PassTextField({
    Key? key,
    required this.validator,
    required this.controller,
    required this.field,
  }) : super(key: key);

  @override
  _PassTextFieldState createState() => _PassTextFieldState();
}

class _PassTextFieldState extends State<PassTextField> {
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
            controller: widget.controller,
            obscureText: _obscureText,
            validator: widget.validator,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.lock,
              ),
              hintText: widget.field,
              suffixIcon: IconButton(
                icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: _toggle,
              ),
            ),
    );
  }
}