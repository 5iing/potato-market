import 'package:flutter/material.dart';
import 'package:potato_market/pages/mypage/my_page.dart';
import '../pages/home/home_page.dart';
import '../pages/nearby/nearby_page.dart';
import '../pages/chat/chat_page.dart';
import 'nav_bar.dart';

class TabView extends StatefulWidget {
  const TabView({super.key});

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  int _index = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const NearbyPage(),
    const ChatPage(),
    const MyPage(),
  ];

  void _onTabChanged(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _index,
        onTap: _onTabChanged,
      ),
    );
  }
}
