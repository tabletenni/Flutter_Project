// import 'package:flutter/material.dart';
// import 'package:test/model/Employee.dart';
// import 'package:test/screen/detailEmployee.dart';
// import 'package:test/services/firestore.dart';

// class EmployeeListPage extends StatefulWidget {
//   const EmployeeListPage({super.key});

//   @override
//   State<EmployeeListPage> createState() => _EmployeeListPageState();
// }

// class _EmployeeListPageState extends State<EmployeeListPage> {
//   String searchQuery = '';
//   String? selectedServiceType = 'ทั้งหมด';

//   final FirestoreService firestoreService = FirestoreService();

//   final List<String> serviceType = [
//     'ทั้งหมด',
//     'ทำความสะอาด',
//     'ดูแลสวน',
//     'ดูแลผู้สูงอายุ',
//     'ดูแลสัตว์เลี้ยง'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         title: const Text(
//           'รายชื่อพนักงาน',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.blueGrey[700],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             buildSearchField(),
//             const SizedBox(height: 16),
//             buildDropdownField(),
//             const SizedBox(height: 16),

//             // รายชื่อพนักงาน (ดึงจาก Firestore)
//             StreamBuilder<List<Employee>>(
//               stream: firestoreService.getEmployees(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       'ไม่พบพนักงาน',
//                       style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blueGrey),
//                     ),
//                   );
//                 }

//                 // กรองข้อมูลจาก Search และ Dropdown
//                 final filteredEmployees = snapshot.data!.where((employee) {
//                   final matchesSearch = employee.name
//                       .toLowerCase()
//                       .contains(searchQuery.toLowerCase());
//                   final matchesFilter = selectedServiceType == 'ทั้งหมด' ||
//                       employee.serviceType == selectedServiceType;
//                   return matchesSearch && matchesFilter;
//                 }).toList();

//                 // เรียงลำดับตามตัวอักษร (รองรับทั้งภาษาไทยและอังกฤษ)
//                 filteredEmployees.sort((a, b) => a.name.compareTo(b.name));

//                 return ListView.builder(
//                   itemCount: filteredEmployees.length,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     final employee = filteredEmployees[index];
//                     return buildEmployeeCard(employee);
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// ฟังก์ชันสร้าง Card แสดงข้อมูลพนักงาน
//   Widget buildEmployeeCard(Employee employee) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 2,
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(16),
//         leading: FutureBuilder<String>(
//           future: firestoreService.getImageEmpolyee(employee.imageUrl),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const CircleAvatar(
//                 radius: 30,
//                 backgroundColor: Colors.grey,
//                 child: CircularProgressIndicator(),
//               );
//             }

//             if (snapshot.hasError || snapshot.data!.isEmpty) {
//               return const CircleAvatar(
//                 radius: 30,
//                 backgroundColor: Colors.blueGrey,
//                 child: Icon(Icons.person, color: Colors.white, size: 25),
//               );
//             }

//             return CircleAvatar(
//               radius: 30,
//               backgroundImage: NetworkImage(snapshot.data!),
//             );
//           },
//         ),
//         title: Text(
//           employee.name,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(
//           employee.serviceType,
//           style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
//         ),
//         trailing: const Icon(Icons.arrow_forward_ios,
//             size: 16, color: Colors.blueGrey),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => DetailEmployeePage(
//                 employee: employee,
//                 documentId: employee.id,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   /// ฟังก์ชันสร้างช่องค้นหา
//   Widget buildSearchField() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
//         ],
//       ),
//       child: TextField(
//         decoration: const InputDecoration(
//           hintText: 'ค้นหาพนักงาน...',
//           prefixIcon: Icon(Icons.search, color: Colors.blueGrey),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.all(16),
//         ),
//         onChanged: (value) {
//           setState(() {
//             searchQuery = value;
//           });
//         },
//       ),
//     );
//   }

//   /// ฟังก์ชันสร้าง Dropdown
//   Widget buildDropdownField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'ประเภทงาน',
//           style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.blueGrey),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             boxShadow: const [
//               BoxShadow(
//                   color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
//             ],
//           ),
//           child: DropdownButtonFormField<String>(
//             value: selectedServiceType,
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//               contentPadding:
//                   EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             ),
//             items: serviceType.map((type) {
//               return DropdownMenuItem(value: type, child: Text(type));
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 selectedServiceType = value;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:convert'; // ✅ ใช้สำหรับเรียงลำดับภาษาไทย
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project/page/Admin/detailEmployee.dart';
import 'package:project/page/Admin/model/employee.dart';


class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  String searchQuery = '';
  String? selectedServiceType = 'ทั้งหมด';

  final List<String> serviceType = [
    'ทั้งหมด',
    'ทำความสะอาด',
    'ดูแลสวน',
    'ดูแลผู้สูงอายุ',
    'ดูแลสัตว์เลี้ยง'
  ];

  //ดึงข้อมูลพนักงานจาก Firestore
  Stream<List<Employee>> getEmployees() {
    return FirebaseFirestore.instance.collection("Employee").snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Employee.fromJson(
                  doc.data(), doc.id)) // ✅ ส่ง documentId ด้วย
              .toList(),
        );
  }

  ///ดึง URL ของภาพจาก Firebase Storage (เฉพาะที่เป็น path)
  Future<String> getImageEmployee(String imageUrl) async {
    if (imageUrl.startsWith("http")) {
      return imageUrl; // ถ้าเป็น URL อยู่แล้ว ไม่ต้องโหลดใหม่
    }
    try {
      String downloadUrl =
          await FirebaseStorage.instance.ref(imageUrl).getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint("เกิดข้อผิดพลาดในการโหลดรูป: $e");
      return ""; // ถ้าโหลดไม่ได้ ให้ return ค่าว่าง
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'รายชื่อพนักงาน',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSearchField(),
            const SizedBox(height: 16),
            buildDropdownField(),
            const SizedBox(height: 16),

            //รายชื่อพนักงาน (ดึงจาก Firestore)
            StreamBuilder<List<Employee>>(
              stream: getEmployees(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'ไม่พบพนักงาน',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey),
                    ),
                  );
                }

                //กรองข้อมูลจาก Search และ Dropdown
                final filteredEmployees = snapshot.data!.where((employee) {
                  final matchesSearch = employee.name
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
                  // employee.serviceType.toLowerCase().contains(searchQuery.toLowerCase());
                  final matchesFilter = selectedServiceType == 'ทั้งหมด' ||
                      employee.serviceType == selectedServiceType;
                  return matchesSearch && matchesFilter;
                }).toList();

                //เรียงลำดับตามตัวอักษร (รองรับทั้งภาษาไทยและอังกฤษ)
                filteredEmployees.sort((a, b) => utf8
                    .decode(utf8.encode(a.name))
                    .compareTo(utf8.decode(utf8.encode(b.name))));

                return ListView.builder(
                  itemCount: filteredEmployees.length,
                  shrinkWrap: true, //ป้องกันปัญหาขนาดไม่แน่นอน
                  physics:
                      const NeverScrollableScrollPhysics(), //ป้องกันการเลื่อนซ้อนกัน
                  itemBuilder: (context, index) {
                    final employee = filteredEmployees[index];
                    return buildEmployeeCard(employee);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ///ฟังก์ชันสร้าง Card แสดงข้อมูลพนักงาน
  Widget buildEmployeeCard(Employee employee) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: FutureBuilder<String>(
          future: getImageEmployee(employee.imageUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError || snapshot.data!.isEmpty) {
              return const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person, color: Colors.white, size: 25),
              );
            }

            return CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(snapshot.data!),
            );
          },
        ),
        title: Text(
          employee.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          employee.serviceType,
          style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Colors.blueGrey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailEmployeePage(
                employee: employee,
                documentId: employee.id, // ✅ ส่ง documentId ไป
              ),
            ),
          );
        },
      ),
    );
  }

  ///ฟังก์ชันสร้างช่องค้นหา
  Widget buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'ค้นหาพนักงาน...',
          prefixIcon: Icon(Icons.search, color: Colors.blueGrey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  ///ฟังก์ชันสร้าง Dropdown
  Widget buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ประเภทงาน',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: selectedServiceType,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: serviceType.map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedServiceType = value;
              });
            },
          ),
        ),
      ],
    );
  }
}