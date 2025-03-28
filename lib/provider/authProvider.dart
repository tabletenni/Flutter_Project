import 'package:flutter/material.dart';

class idAllAccountProvider with ChangeNotifier {
  String _uid = "";  // เปลี่ยนชื่อจาก _userId เป็น _docId

  String get uid => _uid;

  void setUid(String uid) {
    _uid = uid;  // เก็บค่า docId
    print('Setting docId to: $_uid');
    notifyListeners();  // แจ้งเตือนผู้ฟังเมื่อมีการเปลี่ยนแปลง
  }
}



class employeeProvider with ChangeNotifier {
  String _empolyeeName = '';

  String get empolyeeName => _empolyeeName;
  void setempolyeeName(String name) {
    _empolyeeName = name;
    notifyListeners();
  }
}
