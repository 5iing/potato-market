import 'article.dart';
import 'user.dart';
// TODO : message

class ChatRoom {
  final int? id;
  final int? articleId;
  final int? buyerId;
  final int? sellerId;
  final String? createdAt;
  final String? uploadedAt;
  final Article article;
  final User buyer;
  final User seller;
  // TODO : chat

  ChatRoom(
      {this.id,
      this.articleId,
      this.buyerId,
      this.sellerId,
      this.createdAt,
      this.uploadedAt,
      required this.article,
      required this.buyer,
      required this.seller});

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      articleId: json['articleId'],
      buyerId: json['buyerId'],
      sellerId: json['sellerId'],
      uploadedAt: json['uploadedAt'],
      article: Article.fromJson(json['article']),
      buyer: User.fromJson(json['buyer']),
      seller: User.fromJson(json['seller']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'articleId': articleId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'createdAt': createdAt,
      'uploadedAt': uploadedAt,
      'article': article.toJson(),
      'buyer': buyer.toJson(),
      'seller': seller.toJson(),
    };
  }
}
