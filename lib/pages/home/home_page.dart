import 'package:flutter/material.dart';
import '../../components/main_article.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _dropdownMenus = ['동패동', '목동동', '교하동'];
  String? _selectedMenu;

  @override
  void initState() {
    super.initState();
    _selectedMenu = _dropdownMenus[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                child: DropdownButton<String>(
                  value: _selectedMenu,
                  hint: const Text(
                    '지역 선택',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  dropdownColor: Colors.white.withOpacity(0.9),
                  elevation: 0,
                  underline: Container(),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                    size: 30,
                  ),
                  items: _dropdownMenus.map((String menu) {
                    return DropdownMenuItem<String>(
                      value: menu,
                      child: Text(
                        menu,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedMenu = value;
                    });
                  },
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black87,
                    size: 24,
                  ),
                  onPressed: () {
                    print('검색 클릭!');
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.black87,
                    size: 24,
                  ),
                  onPressed: () {
                    print('메뉴 클릭');
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.black87,
                    size: 24,
                  ),
                  onPressed: () {
                    print('알림 클릭!');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          MainArticle(
            productName: '닌텐도 스위치',
            hometown: '목동동',
            price: '350,000원',
            uploadedAt: '3시간 전',
          ),
          MainArticle(
            productName: '아이폰 15 Pro',
            hometown: '동패동',
            price: '1,200,000원',
            uploadedAt: '1시간 전',
          ),
          MainArticle(
            productName: '맥북 프로',
            hometown: '교하동',
            price: '2,500,000원',
            uploadedAt: '5시간 전',
          ),
        ],
      ),
    );
  }
}
