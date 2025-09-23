import 'user.dart';

class Article {
  final int? id;
  final int? userId;
  final String? title;
  final String? content;
  final int? price;
  final String? category;
  final String? location;
  final List<String>? images;
  final String? status;
  final int? views;
  final bool? isNegotiable; // 가격 제안 가능 여부
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  Article({
    this.id,
    this.userId,
    this.title,
    this.content,
    this.price,
    this.category,
    this.location,
    this.images,
    this.status,
    this.views,
    this.isNegotiable,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      userId: json['userId'] ?? json['user_id'],
      title: json['title'],
      content: json['content'],
      price: json['price'],
      category: json['category'],
      location: json['location'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      status: json['status'],
      views: json['views'],
      isNegotiable: json['isNegotiable'] ?? json['is_negotiable'] ?? false,
      createdAt: (json['createdAt'] ?? json['created_at']) != null
          ? DateTime.parse(json['createdAt'] ?? json['created_at'])
          : null,
      updatedAt: (json['updatedAt'] ?? json['updated_at']) != null
          ? DateTime.parse(json['updatedAt'] ?? json['updated_at'])
          : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'price': price,
      'category': category,
      'location': location,
      'images': images,
      'status': status,
      'views': views,
      'created_at': createdAt?.toIso8601String(),
      'user': user?.toJson(),
    };
  }
}
