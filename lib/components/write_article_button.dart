import 'package:flutter/material.dart';

class WriteArticleButton extends StatelessWidget {
  const WriteArticleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: Colors.orange,
      decoration: const BoxDecoration(),
      child: GestureDetector(),
    );
  }
}
