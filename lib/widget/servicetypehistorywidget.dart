import 'package:flutter/material.dart';

Widget getServiceTypeWidget(String position) {
  if (position == 'ทำความสะอาด') {
    return Container(
      width: 65, // กำหนดขนาดความกว้าง
      height: 65, // กำหนดขนาดความสูง
      decoration: BoxDecoration(
        color: Colors.green, // สีพื้นหลัง
        shape: BoxShape.circle, // ทำให้เป็นวงกลม
      ),
      child: Center(child: Image.asset('assets/icon/clean.png',height: 40)),
    );
  } else if (position == 'ดูแลสวน') {
    return Container(
      width: 65, // กำหนดขนาดความกว้าง
      height: 65, // กำหนดขนาดความสูง
      decoration: BoxDecoration(
        color: Colors.green, // สีพื้นหลัง
        shape: BoxShape.circle, // ทำให้เป็นวงกลม
      ),
      child: Center(child: Image.asset('assets/icon/can-drop.png',height: 40)),
    );
  } else if (position == 'ดูแลผู้สูงอายุ') {
    return Container(
      width: 65, // กำหนดขนาดความกว้าง
      height: 65, // กำหนดขนาดความสูง
      decoration: BoxDecoration(
        color: Colors.green, // สีพื้นหลัง
        shape: BoxShape.circle, // ทำให้เป็นวงกลม
      ),
      child: Center(child: Image.asset('assets/icon/wheelchair.png',height: 40)),
    );
  } else if (position == 'ดูแลสัตว์เลี้ยง') {
    return Container(
      width: 65, // กำหนดขนาดความกว้าง
      height: 65, // กำหนดขนาดความสูง
      decoration: BoxDecoration(
        color: Colors.green, // สีพื้นหลัง
        shape: BoxShape.circle, // ทำให้เป็นวงกลม
      ),
      child: Center(child: Image.asset('assets/icon/pets.png',height: 40)),
    );
  } else {
    return Text('ไม่พบข้อมูล');
  }
}
