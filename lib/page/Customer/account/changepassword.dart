import 'package:flutter/material.dart';
import 'package:project/function/checktypelogin.dart';
import 'package:project/provider/authProvider.dart';
import 'package:project/service/firestore.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPassWordController = TextEditingController();
  final TextEditingController _newPassWordController = TextEditingController();
  final CheckTypeLogin checkTypeLogin = CheckTypeLogin();
  FirestoreService firestoreService = FirestoreService();
  bool isPasswordUpdated = false; // ตัวแปรเพื่อเก็บสถานะการอัปเดตรหัสผ่าน
  bool isError = false; // ตัวแปรเพื่อเก็บสถานะการเกิดข้อผิดพลาด

  @override
  Widget build(BuildContext context) {
    final docId = Provider.of<idAllAccountProvider>(context).uid;
    bool isGoogleLogin = checkTypeLogin.isLoggedInWithGoogle(); // เช็คว่าล็อกอินผ่าน Google หรือไม่

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 247, 222),
      body: Column(
        children: [
          SizedBox(height: 70),
          Row(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 25, 98, 47),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Text('Change Password',style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)
            ],
          ),
          SizedBox(height: 20),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: _oldPassWordController,
              decoration: InputDecoration(
                hintText: "Enter your old Password",
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
              ),
              enabled: !isGoogleLogin,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: _newPassWordController,
              decoration: InputDecoration(
                hintText: "Enter your New Password",
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
              ),
              enabled: !isGoogleLogin,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(300, 50),
              backgroundColor: Color.fromARGB(255, 25, 98, 47),
            ),
            onPressed: () async {
              String newPassword = _newPassWordController.text;
              String oldPassword = _oldPassWordController.text;

              print("🟡 Updating password...");

              try {
                // เรียกใช้ฟังก์ชันการอัปเดตรหัสผ่าน
                await firestoreService.updatePasswordCustomer(
                  oldPassword,
                  newPassword,
                );

                // อัปเดต UI หลังการอัปเดตสำเร็จ
                setState(() {
                  isPasswordUpdated = true; // อัปเดตสถานะการอัปเดต
                  isError = false; // กรณีไม่มีข้อผิดพลาด
                });

                // Clear the controllers after successful update
                Future.delayed(Duration(seconds: 3), () {
                  setState(() {
                    isPasswordUpdated = false; // ซ่อนข้อความหลังจาก 3 วินาที
                  });
                });

                print('Controller cleared');
              } catch (e) {
                print("Error updating password: $e");
                setState(() {
                  isPasswordUpdated = false; // กรณีมีข้อผิดพลาด
                  isError = true; // กำหนดให้แสดงข้อความข้อผิดพลาด
                });

                Future.delayed(Duration(seconds: 3), () {
                  setState(() {
                    isError = false; // ซ่อนข้อความข้อผิดพลาดหลังจาก 3 วินาที
                  });
                });
              }
              _newPassWordController.clear();
              _oldPassWordController.clear();
            },
            child: Text(
              'Save Change',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          // แสดงข้อความการอัปเดตผล
          if (isPasswordUpdated)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Password updated successfully!',
                style: TextStyle(color: Colors.blueGrey, fontSize: 16),
              ),
            ),
          if (isError && _oldPassWordController.text.isNotEmpty && _newPassWordController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Failed to update password. Please try again.',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
