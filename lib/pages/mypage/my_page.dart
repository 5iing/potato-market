import 'package:flutter/material.dart';
import 'package:potato_market/components/custom_divider.dart';
import '../../services/api_service.dart';
import '../../models/user.dart';
import '../../components/skeleton_loader.dart';

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
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "나의 감자",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                  decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(55))),
                  child: const FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _isLoading
                        ? const SkeletonLoader(width: 100, height: 20)
                        : Text(
                            _user?.name ?? "익명",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                    const SizedBox(height: 4),
                    _isLoading
                        ? const SkeletonLoader(width: 80, height: 14)
                        : Text(
                            _user?.location ?? "알 수 없음",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14),
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
          if (_user != null)
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    padding: const EdgeInsets.all(15),
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
                            const SizedBox(height: 4),
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
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Column(
                    children: [Icon(Icons.receipt_long_outlined), Text('판매내역')],
                  ),
                ),
                Column(
                  children: [Icon(Icons.shopping_bag_outlined), Text('구매내역')],
                ),
                Column(
                  children: [Icon(Icons.favorite_border), Text('관심목록')],
                )
              ],
            ),
          ),
          const CustomDivider(),
          const Padding(
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
