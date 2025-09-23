import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Text('채팅 페이지'),
      ),
    );
  }
}
