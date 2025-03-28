import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/page/Customer/Booking.dart';
import 'package:project/page/Customer/account/account.dart';
import 'package:project/page/Customer/account/account.dart';
import 'package:project/page/Customer/search.dart';
import 'package:project/provider/authProvider.dart';
import 'package:project/service/firestore.dart';
import 'package:project/widget/servicebottom.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirestoreService firestoreService = FirestoreService();
  int indexBottomNav = 0;
  List widgetOption = const [
    Text('home'),
    SearchPage(),
    BookingPage(),
    AccountPage(),
  ];

  late Stream<String> imageStream;

  @override
  Widget build(BuildContext context) {
    final customerDocId = Provider.of<idAllAccountProvider>(context).uid;
    
    print('homedocId $customerDocId');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          getTitle(indexBottomNav),
          style: TextStyle(color: Colors.white),
        ), // ✅ อัปเดต title ตาม index
        backgroundColor: const Color.fromARGB(255, 25, 98, 47),

        elevation: 4.0,
        shadowColor: Colors.black.withOpacity(1),
      ),
      backgroundColor: Color.fromARGB(255, 243, 247, 222),
      body:
          indexBottomNav == 0
              ? Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 15)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 150,
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.only(left: 10)),
                          StreamBuilder<String>(
                            stream: firestoreService.getImageCustomerStream(
                              customerDocId,
                            ), // ใช้ stream ที่เราสร้าง
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(); // แสดงขณะรอข้อมูล
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (snapshot.hasData) {
                                String imageUrl =
                                    snapshot.data ??
                                    ''; // ใช้ค่า default เมื่อ snapshot.data เป็น null
                                if (imageUrl.isEmpty ||
                                    imageUrl == 'ไม่พบข้อมูล') {
                                  return Text(
                                    'ไม่พบข้อมูล',
                                  ); // หรือสามารถใส่ภาพ placeholder ได้
                                } else {
                                  return Flexible(
                                    child: Container(
                                      width: 80, // กำหนดขนาดของวงกลม
                                      height: 80.0,
                                      decoration: BoxDecoration(
                                        shape:
                                            BoxShape
                                                .circle, // ทำให้รูปทรงเป็นวงกลม
                                        image: DecorationImage(
                                          image: NetworkImage(imageUrl),
                                          fit:
                                              BoxFit
                                                  .cover, // ทำให้ภาพครอบคลุมพื้นที่ในวงกลม
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return Text(
                                  'ไม่พบข้อมูล',
                                ); // กรณีที่ snapshot ไม่มีข้อมูล
                              }
                            },
                          ),

                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                             // mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 10,),
                                StreamBuilder<String>(
                                  stream: firestoreService.getUserNameStream(
                                    customerDocId,
                                  ),
                                  builder:
                                      (context, snapshot) => Text(
                                        snapshot.hasData
                                            ? "${snapshot.data}"
                                            : "กำลังโหลด...",

                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                ),
                              Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream: firestoreService.getHistoryHomepage(customerDocId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
        return Center(child: Text("ไม่มีข้อมูลการจอง"));
      }

      // ✅ ตรวจสอบจำนวนเอกสารที่ได้
      print("จำนวนเอกสารที่ดึงมา: ${snapshot.data!.docs.length}");

      // ✅ ดึงแค่เอกสารแรก
      var bookingData = snapshot.data!.docs.first.data() as Map<String, dynamic>;

      // ✅ ตรวจสอบค่าของ bookingData
      print('ข้อมูลที่ดึงได้: $bookingData');

      // ✅ ตรวจสอบค่า selectedDate
      Timestamp? selectedDateTimestamp = bookingData['selectedDate'];
      String selectedDateString = selectedDateTimestamp != null
          ? DateFormat('d MMMM yyyy HH:mm').format(selectedDateTimestamp.toDate())
          : 'ไม่มีข้อมูล';

      return ListTile(
        title: Text(bookingData['address'] ?? 'ไม่มีที่อยู่'),
        subtitle: Text('วันที่จอง: $selectedDateString'),
      );
    },
  ),

                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Text('Service', style: TextStyle(fontSize: 23)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      serviceButton(
                        context,
                        'ทำความสะอาด',
                        'assets/icon/clean.png',
                      ),
                      serviceButton(
                        context,
                        'ดูแลสวน',
                        'assets/icon/can-drop.png',
                      ),
                      serviceButton(
                        context,
                        'ดูแลผู้สูงอายุ',
                        'assets/icon/wheelchair.png',
                      ),
                      serviceButton(
                        context,
                        'ดูแลสัตว์เลี้ยง',
                        'assets/icon/pets.png',
                      ),
                    ],
                  ),
                ],
              )
              : widgetOption[indexBottomNav],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 230, 237, 191),
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: const Color.fromARGB(255, 25, 98, 47),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            backgroundColor: const Color.fromARGB(255, 25, 98, 47),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'Booking',
            backgroundColor: const Color.fromARGB(255, 25, 98, 47),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
            backgroundColor: const Color.fromARGB(255, 25, 98, 47),
          ),
        ],
        currentIndex: indexBottomNav,
        onTap: (value) {
          setState(() {
            indexBottomNav = value;


          });
        },
      ),
    );
  }

  String getTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Search';
      case 2:
        return 'Booking';
      case 3:
        return 'Account';
      default:
        return 'App';
    }
  }
}
