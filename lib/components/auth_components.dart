import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

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
      margin: const EdgeInsets.only(top: 10),
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
  final String label;
  final String hintText;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted;
  final IconData icon;


  const AuthTextField({
    Key? key,
    required this.controller,
    this.focusNode,
    required this.textInputType,
    required this.label,
    required this.hintText,
    required this.validator,
    this.onSubmitted,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: textInputType,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: AppTheme.primaryLightColor,
          ),
          label: const Text(
            'Username',
            style: TextStyle(
              color: AppTheme.primaryLightColor,
            ),
          ),
          hintText: hintText,
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.primaryLightColor)
          ),
        ),
        onFieldSubmitted: onSubmitted,
    );
  }
}

class PassTextField extends StatefulWidget {
  final String?Function(String?)? validator;
  final void Function(String)? onSubmitted;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hint;

  const PassTextField({
    Key? key,
    required this.validator,
    required this.controller,
    this.onSubmitted,
    this.focusNode,
    required this.hint,
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
            focusNode: widget.focusNode,
            onFieldSubmitted: widget.onSubmitted,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.lock,
                color: AppTheme.primaryLightColor,
              ),
              hintText: widget.hint,
              suffixIcon: IconButton(
                icon: Visibility(
                  visible: _obscureText,
                  child: const Icon(Icons.visibility, color: AppTheme.primaryLightColor),
                  replacement: const Icon(Icons.visibility_off, color: AppTheme.primaryLightColor),
                ),
                onPressed: _toggle,
              ),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryLightColor)
              ),
            ),
    );
  }
}