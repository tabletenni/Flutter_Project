import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/page/Customer/employee.dart';
import 'package:project/service/firestore.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();
  String searchQuery = '';

  // ฟังก์ชันค้นหาข้อมูลจาก Firestore
  Stream<QuerySnapshot> searchEmployee(String query) {
    if (query.isEmpty) {
      return firestoreService.getEmployee(); // ถ้าไม่มีคำค้น ก็ดึงข้อมูลทั้งหมด
    } else {
      return firestoreService.searchEmployee(query); // ฟังก์ชันค้นหาจากคำค้น
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 247, 222),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              controller: searchController,
              hintText: 'Search',
              leading: Icon(Icons.search),
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // อัปเดตคำค้น
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: searchEmployee(
                searchQuery,
              ), // ดึงข้อมูลจาก Firestore ตามคำค้น
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var employees = snapshot.data!.docs;

                if (employees.isEmpty) {
                  return Center(child: Text("No results found"));
                }

                return ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    var doc = employees[index];
                    String imagePath =
                        doc['imageUrl']; // Path ของไฟล์ใน Storage
                    String documentId = doc.id;
                    String name = doc['name'] ?? 'Unknown';
                    String type = doc['serviceType'] ?? '';
                    String employeeId = doc['id'];

                    return FutureBuilder<String>(
                      future: firestoreService.getImageEmpolyee(
                        imagePath,
                      ), // ดึง URL ของรูปจาก Storage
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox.shrink(); // โหลด URL อยู่
                        }

                        String imageUrl = snapshot.data!;

                        return InkWell(
                          onTap: () {
                            // ไปที่หน้า EmployeePage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => EmployeePage(
                                      documentId: documentId,
                                      name: name,
                                      image: imageUrl,
                                      type: type,
                                    ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Center(
                              child: SizedBox(
                                height: 300,
                                width: 300,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                         Align(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                SizedBox(width: 4),
                                                StreamBuilder(
                                                  stream: firestoreService
                                                      .getRating(employeeId),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    }
                                                    if (!snapshot.hasData ||
                                                        snapshot
                                                            .data!
                                                            .isEmpty) {
                                                      return const Text(
                                                        "0.0",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.grey,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      );
                                                    }

                                                    final reviews =
                                                        snapshot
                                                            .data!; // List<Map<String, dynamic>>

                                                    // คำนวณค่าเฉลี่ยของ rating ทั้งหมด
                                                    final totalRating = reviews
                                                        .map(
                                                          (review) =>
                                                              (review['rating']
                                                                  as num?) ??
                                                              0,
                                                        )
                                                        .reduce(
                                                          (a, b) => a + b,
                                                        );
                                                    final averageRating =
                                                        totalRating /
                                                        reviews.length;
                                                    // );
                                                   return Row(children: [
                                                     // Icon(Icons.star, color:Colors.yellow),
                                                      SizedBox(width: 5,),
                                                      Text(averageRating.toString())
                                                      ]);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        SizedBox(height: 5),
                                        CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          radius: 70,
                                          backgroundImage: NetworkImage(
                                            imageUrl,
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          type,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
