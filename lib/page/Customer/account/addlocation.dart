import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/page/Customer/account/mapbookmark.dart';
import 'package:project/provider/authProvider.dart';
import 'package:project/service/firestore.dart';
import 'package:provider/provider.dart';

class AddLocationPage extends StatefulWidget {
  const AddLocationPage({super.key});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'บันทึกสถานที่โปรดของคุณ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 25, 98, 47),
        elevation: 4.0,
        shadowColor: Colors.black.withOpacity(1),
      ),
      backgroundColor: Color.fromARGB(255, 243, 247, 222),
      body: Column(
        children: [
          // ใช้ StreamBuilder เพื่อแสดงข้อมูลจาก Firestore
          StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getAddressesStream(
              Provider.of<idAllAccountProvider>(context, listen: false).uid,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // กำลังโหลดข้อมูล
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // ถ้ามีข้อผิดพลาด
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text('No addresses found'); // ถ้าไม่มีข้อมูล
              } else {
                var addresses = snapshot.data!.docs; // ดึงข้อมูลจาก snapshot
                return ListView.builder(
                  shrinkWrap: true, // ลดขนาดให้พอดี
                  physics:
                      NeverScrollableScrollPhysics(), // ปิดการเลื่อนของ ListView
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    var addressData = addresses[index];
                    var address = addressData['address']; // ดึงฟิลด์ 'address'
                    var name = addressData['name']; // ดึงฟิลด์ 'name'
                    var addressDocId = addressData.id;

                    return ListTile(
                      title: Text(name),
                      subtitle: Text(address),
                      leading: Icon(
                        Icons.location_on,
                        color: Color.fromARGB(255, 25, 98, 47),
                      ),
                      trailing: IconButton(
                        onPressed: ()async {
                          await firestoreService.removeAddress(
                              Provider.of<idAllAccountProvider>(context, listen: false).uid,
                              addressDocId,
                            );
                        },
                        icon: Icon(
                          Icons.delete,
                          color: const Color.fromARGB(255, 163, 91, 91),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
          Divider(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (builder) => MapBookMark()),
              );
            },
            child: ListTile(
              title: Text('เพิ่มตำแหน่ง'),
              leading: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
