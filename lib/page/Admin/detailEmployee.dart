// import 'package:flutter/material.dart';
// import 'package:test/model/Employee.dart';
// import 'package:test/model/Review.dart';
// import 'package:test/screen/allReview.dart';
// import 'package:test/services/firestore.dart';

// class DetailEmployeePage extends StatefulWidget {
//   final Employee employee;
//   final String documentId;

//   const DetailEmployeePage({
//     super.key,
//     required this.employee,
//     required this.documentId,
//   });

//   @override
//   State<DetailEmployeePage> createState() => _DetailEmployeePageState();
// }

// class _DetailEmployeePageState extends State<DetailEmployeePage> {
//   final FirestoreService firestoreService = FirestoreService(); // ✅ ใช้ FirestoreService

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         title: Text(
//           widget.employee.name,
//           style: const TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.blueGrey[700],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildEmployeeInfo(),
//             const SizedBox(height: 16),
//             _sectionTitle("ข้อมูลการทำงาน"),
//             _buildWorkInfo(),
//             const SizedBox(height: 16),
//             _buildReviewSection(),
//           ],
//         ),
//       ),
//     );
//   }

//   /// ✅ แสดงข้อมูลพนักงาน
//   Widget _buildEmployeeInfo() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             FutureBuilder<String>(
//               future: firestoreService.getImageEmpolyee(widget.employee.imageUrl), // ✅ โหลดรูปจาก FirestoreService
//               builder: (context, snapshot) {
//                 return CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.grey[300],
//                   backgroundImage: snapshot.hasData && snapshot.data!.isNotEmpty
//                       ? NetworkImage(snapshot.data!)
//                       : null,
//                   child: snapshot.connectionState == ConnectionState.waiting
//                       ? const CircularProgressIndicator()
//                       : (snapshot.hasError || snapshot.data!.isEmpty)
//                           ? const Icon(Icons.person, size: 50, color: Colors.grey)
//                           : null,
//                 );
//               },
//             ),
//             const SizedBox(width: 20),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.employee.name,
//                     style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   _infoRow(Icons.person, widget.employee.gender),
//                   _infoRow(Icons.email, widget.employee.email),
//                   _infoRow(Icons.phone, widget.employee.phoneNumber),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// ✅ ข้อมูลการทำงาน
//   Widget _buildWorkInfo() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _infoRow(Icons.work, widget.employee.serviceType),
//             _infoRow(Icons.star, widget.employee.expertiseLevels),
//           ],
//         ),
//       ),
//     );
//   }

//   /// ✅ แสดงรีวิว
//   Widget _buildReviewSection() {
//     return StreamBuilder<List<Review>>(
//       stream: firestoreService.getReviews(widget.documentId), // ✅ ใช้ FirestoreService
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final hasReviews = snapshot.hasData && snapshot.data!.isNotEmpty;
//         final allReviews = snapshot.data ?? [];
//         final displayedReviews = allReviews.take(3).toList();

//         return Column(
//           children: [
//             _sectionTitle(
//               "รีวิวจากลูกค้า",
//               showMore: hasReviews && allReviews.length > 3,
//               onMorePressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AllReviewsPage(employeeId: widget.documentId),
//                   ),
//                 );
//               },
//             ),
//             if (!hasReviews)
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8),
//                 child: Text("ยังไม่มีรีวิว", style: TextStyle(fontSize: 16, color: Colors.grey)),
//               ),
//             if (hasReviews)
//               ...displayedReviews.map((review) => _buildReviewContainer(review)).toList(),
//           ],
//         );
//       },
//     );
//   }

//   /// ✅ แสดงรีวิว
//   Widget _buildReviewContainer(Review review) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.account_circle, size: 40, color: Colors.blueGrey[700]),
//               const SizedBox(width: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(review.reviewerName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                   Row(
//                     children: List.generate(
//                       5,
//                       (index) => Icon(
//                         index < review.rating ? Icons.star : Icons.star_border,
//                         color: Colors.amber,
//                         size: 18,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Text(review.comment, style: const TextStyle(fontSize: 14)),
//         ],
//       ),
//     );
//   }

//   Widget _infoRow(IconData icon, String text) {
//     return Row(children: [Icon(icon, color: Colors.blueGrey, size: 20), const SizedBox(width: 8), Expanded(child: Text(text, style: const TextStyle(fontSize: 16)))]);
//   }
// }

//  Widget _sectionTitle(String title,
//       {bool showMore = false, VoidCallback? onMorePressed}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blueGrey),
//           ),
//           if (showMore) ...[
//             const Spacer(),
//             TextButton(
//               onPressed: onMorePressed,
//               child: const Text("ทั้งหมด",
//                   style: TextStyle(color: Colors.blueGrey, fontSize: 16)),
//             ),
//           ]
//         ],
//       ),
//     );
//   }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project/page/Admin/model/employee.dart';
import 'package:project/page/Admin/model/review.dart';

// import 'package:test/screen/allReview.dart';

class DetailEmployeePage extends StatefulWidget {
  final Employee employee;
  final String documentId; // ID ของ Employee ใน Firestore

  const DetailEmployeePage({
    super.key,
    required this.employee,
    required this.documentId,
  });

  @override
  State<DetailEmployeePage> createState() => _DetailEmployeePageState();
}

class _DetailEmployeePageState extends State<DetailEmployeePage> {
  /// ✅ ดึง URL ของรูปโปรไฟล์ (ถ้าไม่มีให้ใช้ default_profile.png)
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

  Future<String> getCustomerName(String customerId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> customerDoc =
          await FirebaseFirestore.instance
              .collection("Customer")
              .doc(customerId)
              .get();

      if (customerDoc.exists && customerDoc.data() != null) {
        return customerDoc.data()!['userName'] ?? "ไม่ระบุชื่อ";
      }
    } catch (e) {
      debugPrint("❌ ดึงชื่อผู้ใช้ผิดพลาด: $e");
    }
    return "ไม่ระบุชื่อ";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          widget.employee.name,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmployeeInfo(),
            const SizedBox(height: 16),
            _sectionTitle("ข้อมูลการทำงาน"),
            _buildWorkInfo(),
            const SizedBox(height: 16),
            _sectionTitle("ข้อมูลการรีวิว"),
            _buildReviewSection(),
          ],
        ),
      ),
    );
  }

  /// ✅ แสดงข้อมูลพนักงาน
  Widget _buildEmployeeInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            FutureBuilder<String>(
              future: getImageEmployee(widget.employee.imageUrl),
              builder: (context, snapshot) {
                return CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: snapshot.hasData && snapshot.data!.isNotEmpty
                      ? NetworkImage(
                          snapshot.data!) // ✅ โหลดจาก Firebase Storage
                      : null,
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? const CircularProgressIndicator() // ✅ กำลังโหลด
                      : (snapshot.hasError || snapshot.data!.isEmpty)
                          ? const Icon(Icons.person,
                              size: 50,
                              color: Colors.grey) // ✅ ใช้ icon ถ้าโหลดไม่ได้
                          : null,
                );
              },
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.employee.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _infoRow(Icons.person, widget.employee.gender),
                  _infoRow(Icons.email, widget.employee.email),
                  _infoRow(Icons.phone, widget.employee.phoneNumber),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ ข้อมูลการทำงาน
  Widget _buildWorkInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow(Icons.work, widget.employee.serviceType),
            _infoRow(Icons.star, widget.employee.expertiseLevels),
          ],
        ),
      ),
    );
  }

  /// ✅ แสดงรีวิว พร้อมปุ่ม "เพิ่มรีวิว"
  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<List<Review>>(
          stream: getReviews(widget.documentId),
          builder: (context, snapshot) {
            debugPrint(
                "📡 StreamBuilder: hasData=${snapshot.hasData}, isEmpty=${snapshot.data?.isEmpty}");

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: Text(
                    "ยังไม่มีรีวิว",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              );
            }

            final allReviews = snapshot.data!;
            final displayedReviews = allReviews.take(3).toList();

            return Column(
              children: displayedReviews.map((review) {
                debugPrint(
                    "🎯 รีวิวที่จะแสดง: ${review.reviewerName} (${review.rating} ดาว)");
                return _buildReviewContainer(review);
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 16),
        // ElevatedButton.icon(
        //   onPressed: () => _showAddReviewDialog(),
        //   icon: const Icon(Icons.rate_review),
        //   label: const Text("เพิ่มรีวิว"),
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: Colors.blueGrey[700],
        //     foregroundColor: Colors.white,
        //   ),
        // ),
      ],
    );
  }

  // void _showAddReviewDialog() {
  //   final TextEditingController nameController = TextEditingController();
  //   final TextEditingController commentController = TextEditingController();
  //   int rating = 3; // ค่าเริ่มต้น

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text("เพิ่มรีวิว"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: nameController,
  //               decoration: const InputDecoration(labelText: "ชื่อของคุณ"),
  //             ),
  //             const SizedBox(height: 10),
  //             TextField(
  //               controller: commentController,
  //               decoration: const InputDecoration(labelText: "ความคิดเห็น"),
  //               maxLines: 3,
  //             ),
  //             const SizedBox(height: 10),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 const Text("ให้คะแนน:"),
  //                 DropdownButton<int>(
  //                   value: rating,
  //                   items: List.generate(5, (index) {
  //                     return DropdownMenuItem(
  //                       value: index + 1,
  //                       child: Text("${index + 1} ดาว"),
  //                     );
  //                   }),
  //                   onChanged: (value) {
  //                     setState(() {
  //                       rating = value ?? 3;
  //                     });
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text("ยกเลิก"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               _addReview(nameController.text, rating, commentController.text);
  //               Navigator.pop(context);
  //             },
  //             child: const Text("บันทึก"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<void> _addReview(String name, int rating, String comment) async {
  //   if (name.isEmpty || comment.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบ")),
  //     );
  //     return;
  //   }

  //   final reviewRef = FirebaseFirestore.instance
  //       .collection("Employee")
  //       .doc(widget.documentId)
  //       .collection("Reviews");

  //   await reviewRef.add({
  //     "reviewerName": name,
  //     "rating": rating,
  //     "comment": comment,
  //     "timestamp": FieldValue.serverTimestamp(),
  //   });

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text("รีวิวถูกบันทึกเรียบร้อย")),
  //   );
  // }

  /// ✅ แสดงรีวิว
Widget _buildReviewContainer(Review review) {
  return FutureBuilder<String>(
    future: getCustomerName(review.customerId), // ดึงชื่อจาก Firestore
    builder: (context, snapshot) {
      String reviewerName = snapshot.connectionState == ConnectionState.waiting
          ? "กำลังโหลด..."
          : snapshot.data ?? "ไม่ระบุชื่อ";

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_circle, size: 40, color: Colors.blueGrey[700]),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reviewerName, // แสดงชื่อแทน customerId
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: List.generate(5, (index) => Icon(
                        index < review.rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 18,
                      )),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(review.comment, style: const TextStyle(fontSize: 14)),
          ],
        ),
      );
    },
  );
}


  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Stream<List<Review>> getReviews(String employeeId) {
    return FirebaseFirestore.instance
        .collection("Employee")
        .doc(employeeId)
        .collection("Reviews")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) {
      debugPrint("🔥 ดึงรีวิวได้ ${snapshot.docs.length} รายการ");

      List<Review> reviews = snapshot.docs
          .map((doc) {
            debugPrint("📌 รีวิวดิบจาก Firestore: ${doc.data()}");
            return Review.fromJson(doc.data(), doc.id);
          })
          .where((review) =>
              review.comment.isNotEmpty) // กรองรีวิวที่ไม่สมบูรณ์ออก
          .toList();

      debugPrint("✅ แปลงเป็น List<Review>: ${reviews.length} รายการ");
      return reviews;
    });
  }

  Widget _sectionTitle(String title,
      {bool showMore = false, VoidCallback? onMorePressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey),
          ),
          if (showMore) ...[
            const Spacer(),
            TextButton(
              onPressed: onMorePressed,
              child: const Text("ทั้งหมด",
                  style: TextStyle(color: Colors.blueGrey, fontSize: 16)),
            ),
          ]
        ],
      ),
    );
  }
}