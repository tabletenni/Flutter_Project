import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:project/page/Customer/paymentpage.dart';
import 'package:project/widget/widget_price.dart';

class DetailBookingPage extends StatefulWidget {
  final String address;
  final String documentId;
  DetailBookingPage({
    super.key,
    required this.address,
    required this.documentId,
  });

  @override
  State<DetailBookingPage> createState() => _DetailBookingPageState();
}

class _DetailBookingPageState extends State<DetailBookingPage> {
  String _selectedDate = 'กรุณาเลือกวันและเวลา';
  bool isSwitched = false;
  int selectedIndex = -1;
  double? selectedPrice;
  TextEditingController _remark = TextEditingController();
  DateTime? _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'ที่อยู่ ${widget.address}',
          style: TextStyle(color: Colors.white),
        ), // ✅ อัปเดต title ตาม index
        backgroundColor: const Color.fromARGB(255, 25, 98, 47),

        elevation: 4.0,
        shadowColor: Colors.black.withOpacity(1),
      ),

      backgroundColor: Color.fromARGB(255, 243, 247, 222),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 17, top: 7, bottom: 5),
              child: Text(
                'ระยะเวลา',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'กรุณาประเมินพื้นที่และเวลาที่ต้องการทำควมสะอาดโปรดเลือก',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Text(
            'เวลางานให้เหมาะสมกับบริการทำความสะอาดตามความต้องการ',
            style: TextStyle(fontSize: 14),
          ),
          Align(
            child: SelectableContainer(
              title: '2 ชั่วโมง',
              subtitle: 'สูงสุด 35m² หรือ 2 ห้อง',
              price: 500.0,
              isSelected: selectedIndex == 0,
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                  selectedPrice = 500.0;
                });
              },
            ),
          ),

          SelectableContainer(
            title: '3 ชั่วโมง',
            subtitle: 'สูงสุด 35-55m² หรือ 3 ห้อง',
            price: 750.0,
            isSelected: selectedIndex == 1,
            onTap: () {
              setState(() {
                selectedIndex = 1;
                selectedPrice = 750.0;
              });
            },
          ),
          SelectableContainer(
            title: '4 ชั่วโมง',
            subtitle: 'สูงสุด 55-100m² หรือ 4 ห้อง',
            price: 950.0,
            isSelected: selectedIndex == 2,
            onTap: () {
              setState(() {
                selectedIndex = 2;
                selectedPrice = 950.0;
              });
            },
          ),

          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 17),
                  child: Text(
                    'เลือกวัน-เวลา',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 40),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 9),
                      child: TextButton(
                        onPressed: () {
                          DatePicker.showDateTimePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime(2020, 1, 1),
                            maxTime: DateTime(2030, 12, 31),
                            onChanged: (date) {
                              _date = date;
                              print(date);
                              // Format วันที่ที่เลือกให้ตรงตามที่ต้องการ
                              String formattedDate = DateFormat(
                                'E, d MMM yyyy h:mm a',
                              ).format(date);
                              setState(() {
                                _selectedDate = formattedDate;
                              });
                            },
                            onConfirm: (date) {
                              // Format วันที่ที่เลือกให้ตรงตามที่ต้องการ
                              String formattedDate = DateFormat(
                                'E, d MMM yyyy h:mm a',
                              ).format(date);
                              setState(() {
                                _selectedDate = formattedDate;
                              });
                            },
                            currentTime: DateTime.now(),
                            locale: LocaleType.en,
                          );
                        },
                        child: Text(
                          _selectedDate,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Text(
                'ตัวเลือก',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 3),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 17),
                  child: Icon(Icons.pets, size: 40),
                ),
                SizedBox(width: 10),
                Text(
                  'บ้านที่มีสัตว์เลี้ยง',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 135),
                Switch(
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
                      print('มีสัตว์เลี้ยง');
                    } else {
                      print('ไม่มีสัตว์เลี้ยง');
                    }
                  },
                ),

                // Text(
                //   isSwitched ? 'มีสัตว์เลี้ยง' : 'ไม่มีสัตว์เลี้ยง',
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 17),
              child: Text(
                'หมายเหตุ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _remark,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'พิมพ์ข้อความที่นี่...', // ข้อความแนะนำ
                    border: InputBorder.none, // ซ่อนเส้นขอบใน TextField
                  ),
                  style: TextStyle(fontSize: 16),
                  scrollPhysics: BouncingScrollPhysics(),
                ),
              ),
            ),
          ),

          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 17),
            child: ElevatedButton(
              onPressed: () {
                if (selectedIndex == -1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('กรุณาเลือกระยะเวลา'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return; // หยุดการทำงานถ้ายังไม่ได้เลือก
                }

                if (_selectedDate == 'กรุณาเลือกวันและเวลา') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'กรุณาเลือกวันและเวลา',
                        style: TextStyle(fontSize: 18),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return; // หยุดการทำงานถ้ายังไม่ได้เลือก
                }

                // ถ้าทุกอย่างถูกต้องไปหน้าถัดไป
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PaymentPage(
                          address: widget.address,
                          selectedDate: _date!,
                          isSwitched:
                              isSwitched == false
                                  ? 'ไม่เลี้ยงสัตว์'
                                  : 'มีสัตว์เลี้ยง',
                          remark: _remark.text,
                          selectedTitle:
                              selectedIndex == 0
                                  ? '2 ชั่วโมง'
                                  : selectedIndex == 1
                                  ? '3 ชั่วโมง'
                                  : '4 ชั่วโมง',
                          selectedSubtitle:
                              selectedIndex == 0
                                  ? 'สูงสุด 35m² หรือ 2 ห้อง'
                                  : selectedIndex == 1
                                  ? 'สูงสุด 35-55m² หรือ 3 ห้อง'
                                  : 'สูงสุด 55-100m² หรือ 4 ห้อง',
                          selectedPrice: selectedPrice ?? 0.0,
                          employeeDocumentId: widget.documentId,
                        ), // เปลี่ยนเป็นหน้าที่ต้องการ
                  ),
                );
                ;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 25, 98, 47),
                minimumSize: Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
