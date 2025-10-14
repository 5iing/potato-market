import 'package:flutter/material.dart';
import 'package:potato_market/components/custom_divider.dart';

class MainChat extends StatefulWidget {
  final bool isLoading = true;

  final String? name;
  final String? location;
  final String? lastChatTime;
  final String? lastChat;

  const MainChat(
      {super.key,
      required this.name,
      required this.location,
      required this.lastChatTime,
      required this.lastChat});

  @override
  _MainChatState createState() => _MainChatState();
}

class _MainChatState extends State<MainChat> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return Container(
      margin: EdgeInsets.zero,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.transparent,
            child: Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(25)),
                    child: Icon(
                      Icons.person,
                      size: 45,
                      color: Colors.grey.shade100,
                    )),
                SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.name ?? '알 수 없음',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${widget.location ?? '알 수 없음'} ${widget.lastChatTime ?? '알 수 없음'}",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(widget.lastChat ?? '알 수 없음'),
                  ],
                ),
                Expanded(
                    child: Container(
                  width: 45,
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.green),
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
          CustomDivider()
        ],
      ),
    );
  }
}
