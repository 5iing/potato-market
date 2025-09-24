import 'package:flutter/material.dart';

class BuyBottomBar extends StatefulWidget {
  final String price;
  final bool isNegotiation;

  const BuyBottomBar(
      {super.key, required this.price, required this.isNegotiation});

  @override
  State<BuyBottomBar> createState() => _BuyBottomBarState();
}

class _BuyBottomBarState extends State<BuyBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black54, width: 0.15)),
        ),
        width: double.infinity,
        height: 120,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    width: 0.5,
                    height: 30,
                    color: Colors.grey,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.price,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Text(
                        widget.isNegotiation ? "가격제안가능" : "가격제안불가",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color:
                              widget.isNegotiation ? Colors.blue : Colors.grey,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: 150,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              alignment: Alignment.center,
              child: const Text(
                "채팅으로 거래하기",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
