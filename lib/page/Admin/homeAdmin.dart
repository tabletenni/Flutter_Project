// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/page/Admin/addEmployee.dart';
import 'package:project/page/Admin/listEmployee.dart';
import 'package:project/page/Admin/promotionMgmt.dart';
import 'package:project/page/Customer/login.dart';
import 'package:project/provider/authProvider.dart';
import 'package:project/service/firestore.dart';
import 'package:provider/provider.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  FirestoreService firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    final AdminId = Provider.of<idAllAccountProvider>(context).uid;
    return Scaffold(
      // สีพื้นหลัง
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170.0),
        child: AppBar(
          backgroundColor: Colors.blueGrey,
          automaticallyImplyLeading: false,
          centerTitle: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          flexibleSpace: StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getWhereDocIdAdmin(AdminId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    "ไม่พบข้อมูล",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              var adminData = snapshot.data!.docs.first;

              // ดึงข้อมูล
              String imageUrl = adminData['imageURL'] ?? '';
              String name = adminData['name'] ?? 'ไม่ระบุชื่อ';

              return Padding(
                padding: const EdgeInsets.only(top: 90, left: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // รูปโปรไฟล์
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : AssetImage('assets/default_avatar.png')
                                  as ImageProvider,
                    ),
                    SizedBox(width: 25, height: 90),
                    // ข้อมูลชื่อ
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (builder) => LoginUserPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Image.asset(
                  'assets/images/power_light.png',
                  width: 20, // ปรับขนาดความกว้าง
                  height: 20, // ปรับขนาดความสูง
                ),
              ),
            ),
          ],
        ),
      ),

      body: ListView(
        children: [
          // Header ส่วนบน
          const SizedBox(height: 30),

          // ปุ่มเมนู
          _buildMenuButton(
            context,
            icon: Icons.person_add_alt,
            label: 'เพิ่มพนักงาน',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEmployeePage(),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          _buildMenuButton(
            context,
            icon: Icons.group,
            label: 'พนักงาน',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmployeeListPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          _buildMenuButton(
            context,
            icon: Icons.campaign,
            label: 'จัดการโปรโมชั่น',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PromotionManagementPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

Widget _buildMenuButton(
  BuildContext context, {
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 16),
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            children: [
              Icon(icon, size: 60, color: Colors.blueGrey[700]),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
