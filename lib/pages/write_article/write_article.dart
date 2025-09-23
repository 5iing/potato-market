import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:potato_market/components/custom_divider.dart';

class WriteArticle extends StatefulWidget {
  @override
  State<WriteArticle> createState() => _WriteArticleState();
}

class _WriteArticleState extends State<WriteArticle> {
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
              onTap: () {
                // TODO: 게시글 저장 로직 추가
                print('완료 버튼 클릭됨!');
                Navigator.pop(context);
              },
              child: Text('완료',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(width: 0.15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt,
                  color: Colors.grey,
                ),
                Text(
                  "0/10",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                )
              ],
            ),
          ),
        ]),
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
          decoration: InputDecoration(
              border: InputBorder.none,
              label: Text('글 제목',
                  style: TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.grey))),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("카테고리 선택", style: TextStyle(fontSize: 16)),
            Icon(
              Icons.arrow_forward,
              color: Colors.black45,
            )
          ],
        ),
      ),
      CustomDivider(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextField(
          decoration: InputDecoration(
              border: InputBorder.none,
              label: Text('가격 입력(선택사항)',
                  style: TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.grey))),
        ),
      ),
      CustomDivider(),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: TextField(
          decoration: InputDecoration(
              border: InputBorder.none,
              label: Text('올릴 게시글 내용을 작성해주세요.(가품 및 판매 금지품목은 게시가 제한될 수 있어요.)',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      height: 1.3))),
        ),
      )
    ]));
  }
}
