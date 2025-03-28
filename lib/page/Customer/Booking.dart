import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/function/durationdate.dart';
import 'package:project/provider/authProvider.dart';
import 'package:project/service/firestore.dart';
import 'package:project/widget/servicetypehistorywidget.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime currentDate = DateTime.now();
  ChangeDuration changeDuration = ChangeDuration();
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 247, 222),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreService.getHistory(
                Provider.of<idAllAccountProvider>(context, listen: false).uid,
              ), // Use getHistory method here
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var data = docs[index].data() as Map<String, dynamic>;

                    List bookingHistory = data['bookingHistory'] ?? [];
                    print('data $data');
                    var employeeDocId = data['employeeDocId'];
                    var address = data['address'];
                    var bookingDate = data['bookingDate'];
                    var selectedDate = data['selectedDate'];
                    DateFormat format = DateFormat("d MMMM yyyy HH:mm");
                    DateTime dateTime = format.parse(bookingDate);
                    Duration difference = currentDate.difference(
                      dateTime,
                    );
                    String formattedDuration = changeDuration
                        .formatDuration(difference);
                    print(formattedDuration);
                   
                      String formattedDate = '';

                      // Check if selectedDate is a Timestamp
                      if (selectedDate is Timestamp) {
                        DateTime dateTime = selectedDate.toDate(); // Convert Timestamp to DateTime
                        formattedDate = DateFormat('d MMMM yyyy HH:mm').format(dateTime); // Format DateTime to String
                      } else {
                        formattedDate = 'ไม่มีข้อมูล'; // Handle null or unexpected types
                      }
                    return Column(
                      children: [
                        // StreamBuilder<String>(
                        //   stream: firestoreService.getServiceTypeStream(
                        //     employeeDocId,
                        //   ),
                        //   builder: (context, snapshot) {
                        //     if (snapshot.connectionState ==
                        //         ConnectionState.waiting) {
                        //       return CircularProgressIndicator(); // กำลังโหลดข้อมูล
                        //     }
                        //     if (snapshot.hasError) {
                        //       return Text("เกิดข้อผิดพลาด");
                        //     }
                        //     return Text(snapshot.data ?? 'ไม่พบข้อมูล');
                        //   },
                        // ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              15,
                            ), // ทำให้ขอบมน
                            side: BorderSide(
                              // เพิ่มขอบ
                              color: Colors.grey, // สีของขอบ
                              width: 1, // ความหนาของขอบ
                            ),
                          ),
                          color: Colors.grey.shade200, // สีพื้นหลังของ Card
                          margin: EdgeInsets.all(10), // ระยะห่างจากขอบ
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                StreamBuilder<String>(
                                  stream: firestoreService.getServiceTypeStream(
                                    employeeDocId,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator(); // กำลังโหลดข้อมูล
                                    }
                                    if (snapshot.hasError) {
                                      return Text("เกิดข้อผิดพลาด");
                                    }
                                    return getServiceTypeWidget(
                                      snapshot.data ?? 'ไม่พบข้อมูล',
                                    ); // แสดงค่าที่โหลดมา
                                  },
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          StreamBuilder<String>(
                                            stream: firestoreService
                                                .getServiceTypeStream(
                                              employeeDocId,
                                            ),
                                            builder: (context, snapshot) => Text(
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
                                          Text(formattedDuration),
                                        ],
                                      ),
                                      SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Text(
                                            'ที่อยู่',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              address,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'จองวันที่',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(formattedDate),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
