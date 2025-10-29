import 'package:flutter/material.dart';

class ChattingPage extends StatefulWidget {
  final String sellerName;

  ChattingPage({super.key, required this.sellerName});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  bool isInputPressed = false;

  final List<Map<String, String>> messages = [
    {'sender': '이연우', 'text': '이거 얼마에요?'},
    {'sender': '홍길동', 'text': '3만원 입니다'},
  ];

  void _handleInput() {
    setState(() {
      isInputPressed = !isInputPressed;
      print(isInputPressed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.sellerName)),
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
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blueAccent : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg['text']!,
                            style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87),
                          ),
                        ));
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () => _handleInput(),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(width: 0.25),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300, // Shadow color
                          offset:
                              Offset(4, 4), // Horizontal and vertical offset
                          blurRadius: 10, // Blur intensity
                          spreadRadius: 2,
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("메세지 보내기",
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500)),
                        Icon(
                          Icons.send,
                          color: Colors.grey.shade500,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // isInputPressed ? TextField()
            SizedBox(
              height: 60,
            )
          ],
        ));
  }
}
