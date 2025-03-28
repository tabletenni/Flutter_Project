import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project/widget/warnphonno.dart';

class FirestoreService {
  Future<String?> getUserType(String userId) async {
    List<String> collections = ['Customer', 'Employee', 'Admin'];

    for (String collection in collections) {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance
              .collection(collection)
              .doc(userId)
              .get();
      if (doc.exists) {
        return collection; // คืนค่าประเภทของ user
      }
    }
    return null;
  }

  // ข้อมูลพนักงาน
  final CollectionReference employee = FirebaseFirestore.instance.collection(
    'Employee',
  );

  Stream<QuerySnapshot> getWhereDocIdEmployee(String docId) {
    // กำหนดการค้นหาตาม docId
    return employee.where(FieldPath.documentId, isEqualTo: docId).snapshots();
  }

Stream<QuerySnapshot> getBookingSelectedDate(
  DateTime? selectDate,
  String employeeId,
) {
  // Remove the time part of selectDate
  DateTime startOfDay = DateTime(selectDate!.year, selectDate.month, selectDate.day);

  // Log the formatted date to check
  print('startOfDay: $startOfDay');

  return employee
      .doc(employeeId) // เลือกพนักงานแต่ละคนจาก ID
      .collection("Booking") // เข้าถึง Collection รีวิวของพนักงานคนนั้น
      .where(
        'selectedDate',
        isGreaterThanOrEqualTo: startOfDay,  // Start of the day
        isLessThanOrEqualTo: startOfDay.add(Duration(days: 1)), // End of the day
      ) // ค้นหาตาม selectedDate ที่ตรงกับวันที่ที่เลือก
      .snapshots(); // ส่งคืนผลลัพธ์เป็น Stream ของ QuerySnapshot
}


  Stream<QuerySnapshot> getWhereDeepCleanStream() {
    final deepCleanStream =
        employee.where('serviceType', isEqualTo: 'ทำความสะอาด').snapshots();
    return deepCleanStream;
  }

  Stream<QuerySnapshot> getWhereGardenStream() {
    final deepCleanStream =
        employee.where('serviceType', isEqualTo: 'ดูแลสวน').snapshots();
    return deepCleanStream;
  }

  Stream<QuerySnapshot> getWhereCareStream() {
    final deepCleanStream =
        employee.where('serviceType', isEqualTo: "ดูแลผู้สูงอายุ").snapshots();
    return deepCleanStream;
  }

  Stream<QuerySnapshot> getWherePetStream() {
    final deepCleanStream =
        employee.where('serviceType', isEqualTo: 'ดูแลสัตว์เลี้ยง').snapshots();
    return deepCleanStream;
  }

  Stream<QuerySnapshot> getEmployee() {
    final employeeSteam = employee.orderBy('name').snapshots();

    return employeeSteam;
  }

  Stream<QuerySnapshot> searchEmployee(String query) {
    if (query.isEmpty) {
      return getEmployee(); // ถ้าไม่มีคำค้นหาให้ดึงข้อมูลทั้งหมด
    }

    return employee
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff') // ค้นหาแบบ prefix
        .snapshots();
  }

  Stream<String> getServiceTypeStream(String docId) {
    final serviceTypeStream = employee
        .doc(docId) // Use the docId to directly access the document
        .snapshots() // Get a stream of the document's snapshots
        .map((snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data() as Map<String, dynamic>;
            final serviceType =
                data['serviceType']?.toString() ??
                'ไม่พบข้อมูล'; // Retrieve serviceType
            return serviceType;
          } else {
            return 'ไม่พบข้อมูล'; // Return default message if document doesn't exist
          }
        });

    return serviceTypeStream;
  }

  Stream<List<Map<String, dynamic>>> getRating(String employeeId) {
    return employee
        .doc(employeeId) // เลือกพนักงานแต่ละคนจาก ID
        .collection("Reviews") // เข้าถึง Collection รีวิวของพนักงานคนนั้น
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data;
          }).toList();
        });
  }

  Stream<List<Map<String, dynamic>>> getReviews(String employeeId) {
    print("Calling getReviews() for employeeId: $employeeId"); // ✅ Debug log

    return employee
        .doc(employeeId) // เลือกพนักงานแต่ละคนจาก ID
        .collection("Reviews") // เข้าถึง Collection รีวิวของพนักงานคนนั้น
        .orderBy("timestamp", descending: true) // เรียงจากรีวิวล่าสุด
        .snapshots()
        .map((snapshot) {
          print(
            "Received snapshot with ${snapshot.docs.length} reviews",
          ); // ✅ Debug log
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            print("Review data: $data"); // ✅ เช็คข้อมูลรีวิวแต่ละอัน
            return data;
          }).toList();
        });
  }

  Future<void> addReview(
    String employeeId,
    double rating,
    String comment,
    String customerId,
  ) async {
    try {
      print("Adding review for employeeId: $employeeId"); // ✅ Debug log

      // อ้างอิงไปที่คอลเลกชัน Reviews ของพนักงาน
      await employee.doc(employeeId).collection("Reviews").add({
        "rating": rating,
        "comment": comment,
        "timestamp": FieldValue.serverTimestamp(),
        'customerId': customerId,
      });

      print("Review added successfully!"); // ✅ Debug log
    } catch (e) {
      print("Error adding review: $e"); // ✅ Debug log สำหรับ error
    }
  }

  Future<String> getImageEmpolyee(String filePath) async {
    try {
      String downloadUrl =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();
      print("Download URL: $downloadUrl");
      return downloadUrl; // คืนค่า URL
    } catch (e) {
      print("เกิดข้อผิดพลาด: $e");
      throw Exception(
        "ไม่สามารถดึง URL ได้",
      ); // ถ้าเกิดข้อผิดพลาด, โยน exception
    }
  }

  Future<void> addHistoryEmployee(
    String userDocID,
    String employeeDocID,
    Map<String, dynamic> booking,
  ) async {
    // ค้นหาลูกค้าจาก userDocID
    QuerySnapshot querySnapshot =
        await employee
            .where(FieldPath.documentId, isEqualTo: employeeDocID)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      // หากพบลูกค้าในฐานข้อมูล
      DocumentReference customerDoc = querySnapshot.docs.first.reference;

      // ใช้ add() เพื่อให้ Firestore สร้าง docId ใหม่สำหรับเอกสารการจองใน collection ใหม่
      DocumentReference newBookingDoc = await customerDoc
          .collection('Booking')
          .add(booking);

      // เพิ่ม historyDocId ลงใน booking หลังจากสร้าง docId ใหม่
      booking['historyDocId'] = newBookingDoc.id;
      await newBookingDoc.update({'historyDocId': newBookingDoc.id});

      print(
        "✅ เพิ่มข้อมูลการจองลงใน collection ใหม่ 'newBookingHistory' สำเร็จ",
      );
      print("📝 historyDocId ของการจองที่สร้างขึ้นใหม่: ${newBookingDoc.id}");
    } else {
      print("❌ ไม่พบลูกค้าในฐานข้อมูล");
    }
  }
  Stream<DocumentSnapshot> getBookingDetailsStream(
  String employeeDocID,
  String bookingId,
) {
  return employee
      .doc(employeeDocID) // ค้นหา employee ตาม employeeDocID
      .collection('Booking') // เข้าถึง collection 'Booking'
      .doc(bookingId) // ค้นหา document โดยใช้ bookingId
      .snapshots(); // รับข้อมูลแบบเรียลไทม์
}

  Future<void> updateFullNameEmployee(String docId, String newUserName) async {
    try {
      DocumentReference customerDoc = FirebaseFirestore.instance
          .collection('Employee')
          .doc(docId); // ใช้ docId แทน userId

      // ตรวจสอบว่า document นี้มีอยู่หรือไม่
      DocumentSnapshot docSnapshot = await customerDoc.get();
      if (docSnapshot.exists) {
        await customerDoc.update({'name': newUserName});
        print("✅ เปลี่ยนชื่อผู้ใช้เป็น '$newUserName' สำเร็จ!");
      } else {
        print("❌ ไม่พบผู้ใช้ที่มี docId = '$docId'");
      }
    } catch (e) {
      print("❌ เกิดข้อผิดพลาด: $e");
    }
  }

  Future<void> updatePhoneNumEmployee(String docId, String newPhoneNum) async {
    try {
      DocumentReference customerDoc = FirebaseFirestore.instance
          .collection('Employee')
          .doc(docId); // ใช้ docId แทน userId

      DocumentSnapshot docSnapshot = await customerDoc.get();
      if (docSnapshot.exists) {
        await customerDoc.update({'phoneNumber': newPhoneNum});
        print("✅ เปลี่ยนเบอร์โทรเป็น '$newPhoneNum' สำเร็จ!");
      } else {
        print("❌ ไม่พบผู้ใช้ที่มี docId = '$docId'");
      }
    } catch (e) {
      print("❌ เกิดข้อผิดพลาด: $e");
    }
  }

  Future<void> updatePasswordEmployee(
  String oldPassword,
  String newPassword,
) async {
  try {
    print("🟡 กำลังอัปเดตรหัสผ่าน...");

    // 🔹 ดึงข้อมูลผู้ใช้จาก Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("❌ ผู้ใช้ไม่ได้เข้าสู่ระบบ");
      return;
    }

    print("🔹 UID ของผู้ใช้ที่เข้าสู่ระบบอยู่: ${user.uid}");

    // 🔹 สร้าง Credential สำหรับการรีออธิเกรน
    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: oldPassword,
    );

    // 🔹 รีออธิเกรนผู้ใช้
    await user.reauthenticateWithCredential(credential);
    print("✅ การรีออธิเกรนสำเร็จ!");

    // 🔹 อัปเดตรหัสผ่านใน Firebase Authentication
    await user.updatePassword(newPassword);
    print("✅ อัปเดตรหัสผ่านใน Firebase Authentication สำเร็จ!");

    // 🔹 อัปเดตรหัสผ่านใน Firestore
    await FirebaseFirestore.instance.collection("Employee").doc(user.uid).update({
      "password": newPassword, // 🔹 เปลี่ยนรหัสผ่านเป็นค่าใหม่
     
    });

    print("✅ อัปเดตรหัสผ่านใน Firestore สำเร็จ!");

  } on FirebaseAuthException catch (e) {
    print("🔥 Firebase Error: ${e.code}");
    print("🔥 Error Message: ${e.message}");
    throw Exception(
      "Error updating password in Firebase Authentication: ${e.message}",
    );
  } catch (e) {
    print("🔥 Error: ${e.toString()}");
    throw Exception("Error updating password: ${e.toString()}");
  }
}






  //--------------------------------------------------------------------
  // ข้อมูล customer
  final CollectionReference customer = FirebaseFirestore.instance.collection(
    'Customer',
  );

  Future<String?> getDocIdByGoogleEmail(String email) async {
    try {
      // ตรวจสอบค่า email ที่ส่งไป
      print('Searching for user with email: $email');

      // ค้นหาเอกสารในคอลเลกชัน 'Customer' ที่มี 'userEmail' ตรงกับอีเมล
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance
              .collection('Customer')
              .where('userEmail', isEqualTo: email)
              .get();

      // ตรวจสอบว่าเจอเอกสารหรือไม่
      if (querySnapshot.docs.isNotEmpty) {
        // ถ้ามีเอกสารที่ตรงกับ email, ดึง docId ของเอกสาร
        String docId = querySnapshot.docs.first.id;
        print('Found docId: $docId');
        return docId;
      } else {
        print('No user found with that email.');
        return null;
      }
    } catch (e) {
      print('Error fetching docId: $e');
      return null;
    }
  }

  Future<Map<String, String?>?> getDocIdByEmail(String email) async {
    try {
      List<String> collections = ['Customer', 'Employee', 'Admin'];

      for (String collection in collections) {
        print('Searching in collection: $collection for email: $email');

        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance
                .collection(collection)
                .where('userEmail', isEqualTo: email)
                .limit(1) // หยุดทันทีที่เจอ
                .get();

        if (querySnapshot.docs.isNotEmpty) {
          String docId = querySnapshot.docs.first.id;
          print('Found docId in $collection: $docId');

          return {
            'docId': docId,
            'userType': collection, // ระบุประเภทของ user
          };
        }
      }

      print('No user found with that email.');
      return null;
    } catch (e) {
      print('Error fetching docId: $e');
      return null;
    }
  }

  Stream<String> getUserNameStream(String docId) {
    final customerStream = customer
        .where(
          FieldPath.documentId,
          isEqualTo: docId,
        ) // ค้นหาจาก docId แทน userId
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            final doc = snapshot.docs.first.data() as Map<String, dynamic>;
            final userName = doc['userName'].toString(); // ดึงข้อมูล userName

            return userName;
          } else {
            return 'ไม่พบข้อมูล';
          }
        });

    return customerStream;
  }
  Stream<String> getUserPhoneNumStream(String docId) {
    final customerStream = customer
        .where(
          FieldPath.documentId,
          isEqualTo: docId,
        ) // ค้นหาจาก docId แทน userId
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            final doc = snapshot.docs.first.data() as Map<String, dynamic>;
            final userName = doc['phoneNum'].toString(); // ดึงข้อมูล userName

            return userName;
          } else {
            return 'ไม่พบข้อมูล';
          }
        });

    return customerStream;
  }

  Future<bool> checkPhoneNoOnce(BuildContext context, String docId) async {
    var querySnapshot =
        await customer.where(FieldPath.documentId, isEqualTo: docId).get();

    if (querySnapshot.docs.isEmpty) {
      print("ไม่พบข้อมูลของเอกสารนี้");
      return false; // แก้ให้คืนค่า false ถ้าไม่พบข้อมูล
    }

    var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
    if (userData.containsKey('phoneNum') &&
        userData['phoneNum'].toString().isNotEmpty) {
      print("มีเบอร์โทร: ${userData['phoneNum']}");
      return true;
    } else {
      showPopup(
        context,
        "แจ้งเตือน",
        "ไม่มีการบันทึกเบอร์โทร กรุณาเพิ่มเบอร์ที่ตั้งค่า",
      );
      return false;
    }
  }

  Stream<String> getImageCustomerStream(String docId) {
    return FirebaseFirestore.instance
        .collection('Customer')
        .doc(docId)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            return snapshot['userPhoto'] ?? 'ไม่พบข้อมูล';
          }
          return 'ไม่พบข้อมูล';
        });
  }

  Stream<QuerySnapshot> getHistory(String userDocId) {
    // ดึงข้อมูลลูกค้าจาก Firestore โดยใช้ docId
    return FirebaseFirestore.instance
        .collection('Customer')
        .doc(userDocId)
        .collection('BookingHistory')
        .orderBy('bookingDate', descending: true)
        .snapshots(); // ส่งคืน Stream ของ QuerySnapshot
  }

 Stream<QuerySnapshot> getHistoryHomepage(String userDocId) {
  DateTime now = DateTime.now();
  Timestamp timestampNow = Timestamp.fromDate(now);

  print("📌 กำลังดึงข้อมูลจาก Firestore...");

  return FirebaseFirestore.instance
      .collection('Customer')
      .doc(userDocId)
      .collection('BookingHistory')
     // .where('status', isEqualTo: "จอง")
      .where('selectedDate', isGreaterThanOrEqualTo: timestampNow)
      .orderBy('selectedDate', descending: false) // เรียงวันที่ใกล้สุดไปไกลสุด
      .limit(1) // 📌 ดึงมาแค่ 1 รายการ
      .snapshots();
}


  Stream<QuerySnapshot> getAddressesStream(String userId) {
    return FirebaseFirestore.instance
        .collection('Customer')
        .doc(userId)
        .collection('addresses')
        .snapshots();
  }

  Future<void> addHistoryCustomer(
    String userDocID,
    String employeeDocID,
    Map<String, dynamic> booking,
  ) async {
    // ค้นหาลูกค้าจาก userDocID
    QuerySnapshot querySnapshot =
        await customer.where(FieldPath.documentId, isEqualTo: userDocID).get();

    if (querySnapshot.docs.isNotEmpty) {
      // หากพบลูกค้าในฐานข้อมูล
      DocumentReference customerDoc = querySnapshot.docs.first.reference;

      // ใช้ add() เพื่อให้ Firestore สร้าง docId ใหม่สำหรับเอกสารการจองใน collection ใหม่
      DocumentReference newBookingDoc = await customerDoc
          .collection('BookingHistory')
          .add(booking);

      // เพิ่ม historyDocId ลงใน booking หลังจากสร้าง docId ใหม่
      booking['historyDocId'] = newBookingDoc.id;
      await newBookingDoc.update({'historyDocId': newBookingDoc.id});

      print(
        "✅ เพิ่มข้อมูลการจองลงใน collection ใหม่ 'newBookingHistory' สำเร็จ",
      );
      print("📝 historyDocId ของการจองที่สร้างขึ้นใหม่: ${newBookingDoc.id}");
    } else {
      print("❌ ไม่พบลูกค้าในฐานข้อมูล");
    }
  }

  Future<void> saveAddress(
    String userId,
    String nameAddress,
    String addaddress,
    LatLng position,
  ) async {
    // สร้างข้อมูลที่อยู่
    Map<String, dynamic> listMarkLocation = {
      'name': nameAddress,
      'address': addaddress,
      'position': GeoPoint(position.latitude, position.longitude),
    };

    // บันทึกที่อยู่และเก็บ addressDocId
    await FirebaseFirestore.instance
        .collection('Customer')
        .doc(userId)
        .collection('addresses')
        .add(listMarkLocation)
        .then((docRef) async {
          // บันทึก addressDocId สำหรับใช้ในการลบ
          await docRef.update({'addressDocId': docRef.id});
        });
  }

  Future<void> updateFullNameCustomer(String docId, String newUserName) async {
    try {
      DocumentReference customerDoc = FirebaseFirestore.instance
          .collection('Customer')
          .doc(docId); // ใช้ docId แทน userId

      // ตรวจสอบว่า document นี้มีอยู่หรือไม่
      DocumentSnapshot docSnapshot = await customerDoc.get();
      if (docSnapshot.exists) {
        await customerDoc.update({'userName': newUserName});
        print("✅ เปลี่ยนชื่อผู้ใช้เป็น '$newUserName' สำเร็จ!");
      } else {
        print("❌ ไม่พบผู้ใช้ที่มี docId = '$docId'");
      }
    } catch (e) {
      print("❌ เกิดข้อผิดพลาด: $e");
    }
  }

  Future<void> updatePhoneNumCustomer(String docId, String newPhoneNum) async {
    try {
      DocumentReference customerDoc = FirebaseFirestore.instance
          .collection('Customer')
          .doc(docId); // ใช้ docId แทน userId

      DocumentSnapshot docSnapshot = await customerDoc.get();
      if (docSnapshot.exists) {
        await customerDoc.update({'phoneNum': newPhoneNum});
        print("✅ เปลี่ยนเบอร์โทรเป็น '$newPhoneNum' สำเร็จ!");
      } else {
        print("❌ ไม่พบผู้ใช้ที่มี docId = '$docId'");
      }
    } catch (e) {
      print("❌ เกิดข้อผิดพลาด: $e");
    }
  }

  Future<void> updatePasswordCustomer(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      print("🟡 กำลังอัปเดตรหัสผ่าน...");

      // 🔹 ดึงข้อมูลผู้ใช้จาก Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print("❌ ผู้ใช้ไม่ได้เข้าสู่ระบบ");
        return;
      }

      print("🔹 UID ของผู้ใช้ที่เข้าสู่ระบบอยู่: ${user.uid}");

      // 🔹 ดึง docId จาก Stream

      // 🔹 สร้าง Credential สำหรับการรีออธิเกรน
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      // 🔹 รีออธิเกรนผู้ใช้
      await user.reauthenticateWithCredential(credential);
      print("✅ การรีออธิเกรนสำเร็จ!");

      // 🔹 อัปเดตรหัสผ่านใน Firebase Authentication
      await user.updatePassword(newPassword);
      print("✅ อัปเดตรหัสผ่านใน Firebase Authentication สำเร็จ!");
    } on FirebaseAuthException catch (e) {
      print("🔥 Firebase Error: ${e.code}");
      print("🔥 Error Message: ${e.message}");
      throw Exception(
        "Error updating password in Firebase Authentication: ${e.message}",
      );
    } catch (e) {
      print("🔥 Error: ${e.toString()}");
      throw Exception("Error updating password: ${e.toString()}");
    }
  }

  // delete
  Future<void> removeAddress(String userId, String addressDocId) async {
    DocumentReference addressDoc = FirebaseFirestore.instance
        .collection('Customer')
        .doc(userId)
        .collection('addresses')
        .doc(addressDocId);

    // ลบที่อยู่
    await addressDoc.delete();
  }

  //-------------------------
  final CollectionReference booking = FirebaseFirestore.instance.collection(
    'Booking',
  );
  // บันทึกการจอง
  Future<void> addBooking(
    String customerDocId,
    String employeeDocId,
    String address,
    String bookingDate,
    String serviceDate,
    String detail,
    double totalPrice,
    String status,
  ) async {
    DocumentReference documentReference = await booking.add({
      'customer': customerDocId,
      'employee': employeeDocId,
      'address': address,
      'bookingDate': bookingDate,
      'serviceDate': serviceDate,
      'detail': detail,
      'totalPrice': totalPrice,
      'status': status,
    });

    // อัปเดต docId ให้เอกสาร
    await documentReference.update({'docId': documentReference.id});
  }

//----------ADMIn
final CollectionReference admin = FirebaseFirestore.instance.collection(
    'Admin',
  );
Stream<QuerySnapshot> getWhereDocIdAdmin(String docId) {
    // กำหนดการค้นหาตาม docId
    return admin.where(FieldPath.documentId, isEqualTo: docId).snapshots();
  }





}

