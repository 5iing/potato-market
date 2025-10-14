import 'package:flutter/material.dart';

class ChattingPage extends StatelessWidget {
  ChattingPage({super.key});

  final List<Map<String, String>> messages = [
    {'sender': '이연우', 'text': '이거 얼마에요?'},
    {'sender': '홍길동', 'text': '3만원 입니다'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("홍길동")),
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg['sender'] == '이연우';

                      return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  isMe ? Colors.blueAccent : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              msg['text']!,
                              style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black87),
                            ),
                          ));
                    }))
          ],
        ));
  }
}
