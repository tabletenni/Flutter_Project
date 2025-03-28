import 'package:flutter/material.dart';
import 'package:project/page/Customer/login.dart';
import 'package:project/page/Employee/changePassword.dart';
import 'package:project/page/Employee/checkEarne.dart';
import 'package:project/page/Employee/editProfile.dart';

class EmployeeAccount extends StatefulWidget {
  
  const EmployeeAccount({super.key});

  @override
  State<EmployeeAccount> createState() => _EmployeeAccountState();
}

class _EmployeeAccountState extends State<EmployeeAccount> {
    bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                Container(
                  width: 50.0, // กำหนดขนาดของวงกลม
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/moon_dark.png',
                      height: 35,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  'Change Theme',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 80),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Switch(
                      activeColor: Colors.grey[200], // สีปุ่มตอนเปิด
                      activeTrackColor: Colors.green[400], // สีพื้นหลังตอนเปิด
                      inactiveTrackColor: Colors.white,
                      inactiveThumbColor: Colors.grey,
                      splashRadius: 30,
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                        if (value) {
                          print('dark theme');
                        } else {
                          print('light theme');
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (builder) => EditProfilePage()),
                );
              },
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Container(
                    width: 50.0, // กำหนดขนาดของวงกลม
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(
                        15,
                      ), // ทำให้รูปทรงเป็นวงกลม
                    ),
                    child: Center(
                      // ใช้ Center แทน Align
                      child: Image.asset(
                        'assets/images/editprofile_dark.png',
                        height: 30.0, // ขนาดของรูปภาพ
                        width: 30.0, // ขนาดของรูปภาพ
                      ),
                    ),
                  ),
          
                  SizedBox(width: 15),
                  Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(Icons.chevron_right_rounded, size: 35),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
              },
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Container(
                    width: 50.0, // กำหนดขนาดของวงกลม
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(
                        15,
                      ), // ทำให้รูปทรงเป็นวงกลม
                    ),
                    child: Center(
                      // ใช้ Center แทน Align
                      child: Image.asset(
                        'assets/images/key_dark.png',
                        height: 30.0, // ขนาดของรูปภาพ
                        width: 30.0, // ขนาดของรูปภาพ
                      ),
                    ),
                  ),
          
                  SizedBox(width: 15),
                  Text(
                    'Change Password',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(Icons.chevron_right_rounded, size: 35),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarPage()),
                );
              },
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Container(
                    width: 50.0, // กำหนดขนาดของวงกลม
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(
                        15,
                      ), // ทำให้รูปทรงเป็นวงกลม
                    ),
                    child: Center(
                      // ใช้ Center แทน Align
                      child: Image.asset(
                        'assets/images/sack-dollar.png',
                        height: 30.0, // ขนาดของรูปภาพ
                        width: 30.0, // ขนาดของรูปภาพ
                      ),
                    ),
                  ),
          
                  SizedBox(width: 15),
                  Text(
                    'Check Earn',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(Icons.chevron_right_rounded, size: 35),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginUserPage()),
                );
              },
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Container(
                    width: 50.0, // กำหนดขนาดของวงกลม
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(
                        15,
                      ), // ทำให้รูปทรงเป็นวงกลม
                    ),
                    child: Center(
                      // ใช้ Center แทน Align
                      child: Image.asset(
                        'assets/images/power_dark.png',
                        height: 30.0, // ขนาดของรูปภาพ
                        width: 30.0, // ขนาดของรูปภาพ
                      ),
                    ),
                  ),
          
                  SizedBox(width: 15),
                  Text(
                    'Log Out',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(Icons.chevron_right_rounded, size: 35),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
