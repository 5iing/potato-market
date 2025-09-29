import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/article.dart';

class ApiService {
  static const String baseUrl =
      'https://potato-backend-production.up.railway.app/api';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<Map<String, String>> _getHeaders() async {
    const hardcodedToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImxlZXllb253b29AemVudHJ5by5hcHAiLCJzdWIiOjEsImlhdCI6MTc1ODYwNDc5MSwiZXhwIjoxNzU5MjA5NTkxfQ.IGzs6IwGv1owv0hp6hkkx3v-8L4rqTR3t4uXK_Tl-jY';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $hardcodedToken',
    };

    return headers;
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? location,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'location': location,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['token'] != null) {
        await saveToken(data['token']);
      }
      return data;
    } else {
      throw Exception('회원가입 실패: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['token'] != null) {
        await saveToken(data['token']);
      }
      return data;
    } else {
      throw Exception('로그인 실패: ${response.body}');
    }
  }

  Future<void> logout() async {
    await removeToken();
  }

  Future<User> getUserProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/profile'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('사용자 프로필 API 응답: $data');

      if (data is Map && data.containsKey('data')) {
        return User.fromJson(data['data']);
      } else {
        return User.fromJson(data);
      }
    } else {
      throw Exception('프로필 조회 실패: ${response.body}');
    }
  }

  Future<User> updateUserProfile({
    String? name,
    String? phone,
    String? location,
    String? profileImage,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user/profile'),
      headers: await _getHeaders(),
      body: jsonEncode({
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (location != null) 'location': location,
        if (profileImage != null) 'profile_image': profileImage,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('프로필 수정 실패: ${response.body}');
    }
  }

  Future<List<Article>> getArticles({
    int page = 1,
    int limit = 20,
    String? category,
    String? location,
    String? search,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (category != null) queryParams['category'] = category;
    if (location != null) queryParams['location'] = location;
    if (search != null) queryParams['search'] = search;

    final uri =
        Uri.parse('$baseUrl/articles').replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('API 응답 데이터: $data');

      List<dynamic> articlesJson;
      if (data is List) {
        articlesJson = data;
      } else if (data is Map &&
          data.containsKey('data') &&
          data['data'].containsKey('articles')) {
        articlesJson = data['data']['articles'];
      } else if (data is Map && data.containsKey('articles')) {
        articlesJson = data['articles'];
      } else if (data is Map &&
          data.containsKey('data') &&
          data['data'] is List) {
        articlesJson = data['data'];
      } else {
        articlesJson = [];
      }

      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('게시글 목록 조회 실패: ${response.body}');
    }
  }

  Future<Article> getArticle(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/articles/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('게시글 상세 API 응답: $data');

      if (data is Map && data.containsKey('data')) {
        return Article.fromJson(data['data']);
      } else {
        return Article.fromJson(data);
      }
    } else {
      throw Exception('게시글 조회 실패: ${response.body}');
    }
  }

  Future<Article> createArticle({
    required String title,
    required String content,
    required int price,
    required String category,
    required String location,
    List<String>? images,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/articles'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'title': title,
        'content': content,
        'price': price,
        'category': category,
        'location': location,
        'images': images ?? [],
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('게시글 작성 응답: $data');

      if (data is Map && data.containsKey('data')) {
        return Article.fromJson(data['data']);
      } else {
        return Article.fromJson(data);
      }
    } else {
      throw Exception('게시글 작성 실패: ${response.body}');
    }
  }

  Future<Article> updateArticle({
    required int id,
    String? title,
    String? content,
    int? price,
    String? category,
    String? location,
    List<String>? images,
    String? status,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/articles/$id'),
      headers: await _getHeaders(),
      body: jsonEncode({
        if (title != null) 'title': title,
        if (content != null) 'content': content,
        if (price != null) 'price': price,
        if (category != null) 'category': category,
        if (location != null) 'location': location,
        if (images != null) 'images': images,
        if (status != null) 'status': status,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Article.fromJson(data);
    } else {
      throw Exception('게시글 수정 실패: ${response.body}');
    }
  }

  Future<void> deleteArticle(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/articles/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('게시글 삭제 실패: ${response.body}');
    }
  }

  Future<List<Article>> getMyArticles() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/articles'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> articlesJson = data['articles'] ?? data;
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('내 게시글 조회 실패: ${response.body}');
    }
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload/image'),
      );

      final headers = await _getHeaders();
      request.headers.addAll(headers);
      request.files.add(
        await http.MultipartFile.fromPath(
          'images',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('이미지 업로드 응답: $data');

        if (data is Map &&
            data.containsKey('images') &&
            data['images'] is List) {
          final images = data['images'] as List;
          if (images.isNotEmpty) {
            return images[0];
          }
        } else if (data is Map &&
            data.containsKey('data') &&
            data['data'].containsKey('url')) {
          return data['data']['url'];
        } else if (data is Map && data.containsKey('url')) {
          return data['url'];
        } else if (data is Map && data.containsKey('imageUrl')) {
          return data['imageUrl'];
        }
        throw Exception('이미지 URL을 찾을 수 없습니다: $data');
      } else {
        throw Exception('이미지 업로드 실패: ${response.body}');
      }
    } catch (e) {
      throw Exception('이미지 업로드 에러: $e');
    }
  }

  Future<List<String>> uploadMultipleImages(List<File> imageFiles) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload/image'),
      );

      final headers = await _getHeaders();
      request.headers.addAll(headers);

      for (final imageFile in imageFiles) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images',
            imageFile.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('여러 이미지 업로드 응답: $data');

        if (data is Map &&
            data.containsKey('images') &&
            data['images'] is List) {
          return List<String>.from(data['images']);
        }
        throw Exception('이미지 URL 배열을 찾을 수 없습니다: $data');
      } else {
        throw Exception('여러 이미지 업로드 실패: ${response.body}');
      }
    } catch (e) {
      print('여러 이미지 업로드 에러: $e');
      return await _uploadImagesIndividually(imageFiles);
    }
  }

  Future<List<String>> _uploadImagesIndividually(List<File> imageFiles) async {
    final List<String> imageUrls = [];

    for (final imageFile in imageFiles) {
      try {
        final imageUrl = await uploadImage(imageFile);
        imageUrls.add(imageUrl);
      } catch (e) {
        print('개별 이미지 업로드 실패: $e');
      }
    }

    return imageUrls;
  }
}
