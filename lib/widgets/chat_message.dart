import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.uid, required this.message, required this.animationController});

  final String uid;
  final String message;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: uid == '123' ? _myMessage() : _notMyMessage(),
        ),
      ),
    );
  }

  _myMessage() => Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 5.0, left: 50.0, right: 5.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: const Color(0xff4D9EF6),
              borderRadius: BorderRadius.circular(20.0)),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
  _notMyMessage() => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 5.0, left: 5.0, right: 50.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: const Color(0xffE4E5E8),
              borderRadius: BorderRadius.circular(20.0)),
          child: Text(
            message,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      );
}
