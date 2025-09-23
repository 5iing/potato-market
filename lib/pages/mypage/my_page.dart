import 'package:flutter/material.dart';
import 'package:potato_market/components/custom_divider.dart';
import '../../services/api_service.dart';
import '../../models/user.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      print('사용자 프로필 로딩 시작');
      final user = await _apiService.getUserProfile();
      print('받은 사용자 데이터: ${user.name}, ${user.location}');

      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      print('사용자 프로필 로딩 에러: $e');
    }
  }

  // 매너온도에 따른 색상 반환
  Color _getTemperatureColor(double? temperature) {
    if (temperature == null) return Colors.blue;

    if (temperature <= 40.0) {
      return Colors.blue;
    } else if (temperature <= 70.0) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // 매너온도에 따른 배경색 반환
  Color _getTemperatureBackgroundColor(double? temperature) {
    if (temperature == null) return Colors.blue[50]!;

    if (temperature <= 40.0) {
      return Colors.blue[50]!;
    } else if (temperature <= 70.0) {
      return Colors.orange[50]!;
    } else {
      return Colors.red[50]!;
    }
  }

  // 매너온도에 따른 테두리 색상 반환
  Color _getTemperatureBorderColor(double? temperature) {
    if (temperature == null) return Colors.blue[200]!;

    if (temperature <= 40.0) {
      return Colors.blue[200]!;
    } else if (temperature <= 70.0) {
      return Colors.orange[200]!;
    } else {
      return Colors.red[200]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "나의 감자",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Icon(Icons.settings)
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CustomDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(55))),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      _isLoading ? "로딩중..." : (_user?.name ?? "익명"),
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    Text(
                      _isLoading ? "..." : (_user?.location ?? "알 수 없음"),
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: GestureDetector(
              onTap: _error != null ? _loadUserProfile : null,
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.005, color: Colors.grey),
                  color: _error != null ? Colors.red[50] : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  _error != null ? '다시 시도' : '프로필 보기',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: _error != null ? Colors.red : Colors.black,
                  ),
                ),
              ),
            ),
          ),
          // 매너온도 섹션
          if (_user != null)
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: _getTemperatureBackgroundColor(_user!.temperature),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color:
                              _getTemperatureBorderColor(_user!.temperature)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '매너온도',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${_user!.temperature?.toStringAsFixed(1) ?? "36.5"}°C',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _getTemperatureColor(_user!.temperature),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.thermostat,
                          color: _getTemperatureColor(_user!.temperature),
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [Icon(Icons.receipt), Text('판매내역')],
                ),
                Column(
                  children: [Icon(Icons.receipt), Text('판매내역')],
                ),
                Column(
                  children: [Icon(Icons.receipt), Text('판매내역')],
                )
              ],
            ),
          ),
          CustomDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.pin,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '내 동네 설정',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.pin,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '내 동네 설정',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.pin,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '내 동네 설정',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
