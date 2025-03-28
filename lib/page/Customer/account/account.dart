import 'package:flutter/material.dart';
import 'package:project/page/Customer/account/addlocation.dart';
import 'package:project/page/Customer/account/changepassword.dart';
import 'package:project/page/Customer/account/editprofile.dart';
import 'package:project/page/Customer/login.dart';
import 'package:project/provider/authProvider.dart';
import 'package:project/service/firestore.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  FirestoreService firestoreService = FirestoreService();
  bool isSwitched = false;
  late Stream<String> imageStream;
  @override
  Widget build(BuildContext context) {
    final docId = Provider.of<idAllAccountProvider>(context).uid;
    var imageStream = firestoreService.getImageCustomerStream(docId);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 247, 222),
      body: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: Container(
              child: StreamBuilder<String>(
                stream: imageStream, // ใช้ stream ที่เราสร้าง
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // แสดงขณะรอข้อมูล
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    String imageUrl = snapshot.data ?? 'ไม่พบข้อมูล';
                    return imageUrl == 'ไม่พบข้อมูล'
                        ? Text(imageUrl)
                        : ClipOval(
                          child: Container(
                            width: 120, // กำหนดขนาดของวงกลม
                            height: 120.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                15,
                              ), // ทำให้รูปทรงเป็นวงกลม
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit:
                                    BoxFit
                                        .cover, // ทำให้ภาพครอบคลุมพื้นที่ในวงกลม
                              ),
                            ),
                          ),
                        ); // แสดงรูปภาพหากมี URL
                  } else {
                    return Text('ไม่พบข้อมูล');
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 15),
          StreamBuilder<String>(
            stream: firestoreService.getUserNameStream(docId),
            builder:
                (context, snapshot) => Text(
                  snapshot.hasData ? "${snapshot.data}" : "กำลังโหลด...",

                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          SizedBox(height: 10),
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
                  MaterialPageRoute(builder: (context) => AddLocationPage()),
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
                        'assets/images/location_dark.png',
                        height: 30.0, // ขนาดของรูปภาพ
                        width: 30.0, // ขนาดของรูปภาพ
                      ),
                    ),
                  ),

                  SizedBox(width: 15),
                  Text(
                    'Add location',
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
