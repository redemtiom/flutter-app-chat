import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  const BlueButton({super.key, required this.text, required this.onPress});

  final String text;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 2.0,
        shape: const StadiumBorder(),
      ),
      onPressed: onPress,
      child: SizedBox(
        width: double.infinity,
        height: 55.0,
        child: Center(
            child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 17.0),
        )),
      ),
    );
  }
}
