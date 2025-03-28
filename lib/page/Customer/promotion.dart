import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/Data/promotion.dart';

class PromotionPage extends StatelessWidget {
  final List<Promotion> promotion_list;

  const PromotionPage({super.key, required this.promotion_list});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โปรโมชัน', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 25, 98, 47),
        centerTitle: false,
      ),
      backgroundColor: Color.fromARGB(255, 243, 247, 222),
      body: ListView(
        children:
            promotion_list.map((promotion) {
              String formattedEndDay = DateFormat(
                'dd MMM yyyy',
              ).format(promotion.endDay);

              return Card(
                margin: EdgeInsets.only(
                  top: 8,
                  left: 5,
                ), // กำหนดระยะห่างของ Card
                color: Colors.white,
                elevation: 0, // ปิดเงา
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // จัดให้อยู่ทางซ้าย
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: 90,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 1,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  promotion.name,
                                  softWrap:
                                      true, // ให้ข้อความขึ้นบรรทัดใหม่อัตโนมัติ
                                  maxLines:
                                      2, // กำหนดให้ขึ้นบรรทัดใหม่ได้สูงสุด 2 บรรทัด
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ส่วนลด ${promotion.name}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('ใช้ได้ถึงวันที่ ${formattedEndDay}'),
                            ],
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                barrierColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(
                                            0,
                                            3,
                                          ), // ตำแหน่งเงา (แนวแกน X, Y)
                                        ),
                                      ],
                                    ),
                                    height: 100,
                                    child: Row(
                                      children: [
                                        SizedBox(width: 35),
                                        Text(
                                          'เลือกโปรโมชัน',
                                          style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 45),
                                        ElevatedButton(
                                          onPressed: () {
                                             Navigator.pop(context); // ปิด BottomSheet
                                             Navigator.pop(context, {
                                              'discount': promotion.discount,
                                              'type': promotion.typePromotion
                                             }); // ปิดหน้าปัจจุบันและส่งค่ากลับ
                                           
                                          },
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(140, 55),
                                            backgroundColor: Colors.green[400],
                                          ),
                                          child: Text(
                                            'นำไปใช้',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              side: BorderSide(
                                color: Colors.blueGrey,
                                width: 1,
                              ),
                            ),
                            child: Icon(Icons.add, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Divider(color: Colors.grey.shade500, thickness: 1),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
