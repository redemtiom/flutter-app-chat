import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      margin: const EdgeInsets.only(top: 50.0),
      width: 200.0,
      child: Column(
        children: [
          const Image(image: AssetImage('assets/tag-logo.png')),
          const SizedBox(height: 20.0),
          Text(
            title,
            style: const TextStyle(fontSize: 30),
          )
        ],
      ),
    ));
  }
}
