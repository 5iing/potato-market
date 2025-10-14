import 'package:flutter/material.dart';
import 'package:potato_market/pages/chatting/chatting_page.dart';
import '../services/api_service.dart';
import '../pages/chat/chat_page.dart';

class BuyBottomBar extends StatefulWidget {
  final String price;
  final bool isNegotiation;
  final bool isLiked;
  final int id;
  final bool isMe;

  const BuyBottomBar(
      {super.key,
      required this.id,
      required this.price,
      required this.isNegotiation,
      required this.isMe,
      required this.isLiked});

  @override
  State<BuyBottomBar> createState() => _BuyBottomBarState();
}

class _BuyBottomBarState extends State<BuyBottomBar> {
  final ApiService _apiService = ApiService();
  late bool _isLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLiked = widget.isLiked;
  }

  Future<void> _createChat({required int id}) async {
    final resp = await _apiService.createChatRoom(id: id);
    if (resp) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChattingPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black54, width: 0.15)),
        ),
        width: double.infinity,
        height: 120,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_isLiked) {
                        _apiService.unLikeArticle(id: widget.id);
                        _isLiked = false;
                        setState(() {});
                      } else {
                        _apiService.likeArticle(id: widget.id);
                        _isLiked = true;
                        setState(() {});
                      }
                    },
                    child: _isLiked
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(Icons.favorite_border_outlined),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    width: 0.5,
                    height: 30,
                    color: Colors.grey,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.price,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Text(
                        widget.isNegotiation ? "가격제안가능" : "가격제안불가",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color:
                              widget.isNegotiation ? Colors.blue : Colors.grey,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            GestureDetector(
                onTap: () {
                  if (!widget.isMe) {}
                },
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  alignment: Alignment.center,
                  child: widget.isMe
                      ? Text(
                          "판매완료 처리하기",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                      : GestureDetector(
                          onTap: () => _createChat(id: widget.id),
                          child: Text("채팅으로 거래하기",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                        ),
                ))
          ],
        ),
      ),
    );
  }
}
