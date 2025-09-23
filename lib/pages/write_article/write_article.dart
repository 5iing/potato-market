import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:potato_market/components/custom_divider.dart';
import '../../services/api_service.dart';

class WriteArticle extends StatefulWidget {
  @override
  State<WriteArticle> createState() => _WriteArticleState();
}

class _WriteArticleState extends State<WriteArticle> {
  final ApiService _apiService = ApiService();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  String _selectedCategory = '전자제품';
  bool _isLoading = false;
  List<File> _selectedImages = [];
  bool _isUploadingImages = false;

  final List<String> _categories = [
    '전자제품',
    '의류',
    '가구/인테리어',
    '생활/가공식품',
    '스포츠/레저',
    '취미/게임/음반',
    '도서/티켓/문구',
    '기타'
  ];

  Future<void> _submitArticle() async {
    if (_titleController.text.trim().isEmpty) {
      _showErrorDialog('제목을 입력해주세요.');
      return;
    }

    if (_contentController.text.trim().isEmpty) {
      _showErrorDialog('내용을 입력해주세요.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final price = _priceController.text.trim().isEmpty
          ? 0
          : int.tryParse(_priceController.text.replaceAll(',', '')) ?? 0;

      // 이미지 업로드
      List<String> imageUrls = [];
      if (_selectedImages.isNotEmpty) {
        setState(() {
          _isUploadingImages = true;
        });
        imageUrls = await _apiService.uploadMultipleImages(_selectedImages);
      }

      await _apiService.createArticle(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        price: price,
        category: _selectedCategory,
        location: '목동동', // 기본 위치
        images: imageUrls,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('게시글이 성공적으로 작성되었습니다!')),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('게시글 작성에 실패했습니다: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isUploadingImages = false;
        });
      }
    }
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (images.isNotEmpty && images.length <= 10) {
        setState(() {
          _selectedImages = images.map((image) => File(image.path)).toList();
        });
      } else if (images.length > 10) {
        _showErrorDialog('최대 10장까지만 선택할 수 있습니다.');
      }
    } catch (e) {
      _showErrorDialog('이미지 선택에 실패했습니다: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('오류'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '카테고리 선택',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return ListTile(
                    title: Text(category),
                    trailing: _selectedCategory == category
                        ? Icon(Icons.check, color: Colors.orange)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        body: Column(children: [
      Container(
        height: 100,
        decoration:
            BoxDecoration(border: Border(bottom: BorderSide(width: 0.1))),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text('닫기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            ),
            Text('중고거래 글쓰기',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
            GestureDetector(
              onTap: _isLoading ? null : _submitArticle,
              child: Text(
                _isLoading
                    ? (_isUploadingImages ? '이미지 업로드중...' : '저장중...')
                    : '완료',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: _isLoading ? Colors.grey : Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: Colors.grey[600],
                        size: 24,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${_selectedImages.length}/10",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              ..._selectedImages.asMap().entries.map((entry) {
                int index = entry.key;
                File image = entry.value;
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
      Divider(
        thickness: 1,
        height: 1,
        color: Colors.grey.shade200,
        indent: 16,
        endIndent: 16,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextField(
          controller: _titleController,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '글 제목',
              hintStyle:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.grey)),
        ),
      ),
      Divider(
        thickness: 1,
        height: 1,
        color: Colors.grey.shade200,
        indent: 16,
        endIndent: 16,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GestureDetector(
          onTap: () => _showCategoryPicker(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_selectedCategory, style: TextStyle(fontSize: 16)),
              Icon(
                Icons.arrow_forward,
                color: Colors.black45,
              )
            ],
          ),
        ),
      ),
      CustomDivider(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextField(
          controller: _priceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '가격 입력(선택사항)',
              hintStyle:
                  TextStyle(fontWeight: FontWeight.w400, color: Colors.grey)),
        ),
      ),
      CustomDivider(),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: TextField(
          controller: _contentController,
          maxLines: 5,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '올릴 게시글 내용을 작성해주세요.\n(가품 및 판매 금지품목은 게시가 제한될 수 있어요.)',
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                  height: 1.3)),
        ),
      )
    ]));
  }
}
