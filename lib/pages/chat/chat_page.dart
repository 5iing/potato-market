import 'package:flutter/material.dart';
import 'package:potato_market/pages/chatting/chatting_page.dart';
import '../../components/custom_divider.dart';
import '../../components/main_chat.dart';
import '../../models/chat_room.dart';
import '../../services/api_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<ChatRoom> _chatrooms = [];

  @override
  void initState() {
    super.initState();

    _getChatRooms();
  }

  Future<void> _getChatRooms() async {
    try {
      final chatrooms = await _apiService.getChatRooms();
      setState(() {
        _chatrooms = chatrooms;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('채팅방 목록 조회 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("채팅",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _chatrooms.isEmpty
                ? const Center(child: Text('채팅방이 없습니다.'))
                : Column(
                    children: [
                      const CustomDivider(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _chatrooms.length,
                          itemBuilder: (context, index) {
                            final chatroom = _chatrooms[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChattingPage(),
                                  ),
                                );
                              },
                              child: MainChat(
                                name: chatroom.seller.name ?? '알 수 없음',
                                location: chatroom.article.location ?? '알 수 없음',
                                lastChatTime: "3시간 전",
                                lastChat: "이거 얼마에요?",
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ));
  }
}
