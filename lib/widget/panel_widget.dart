import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project/Data/marker_data.dart';
import 'package:project/page/Customer/detailbooking.dart';
import 'package:project/provider/authProvider.dart';
import 'package:project/service/firestore.dart';
import 'package:provider/provider.dart';

class PanelWidget extends StatefulWidget {
  final String documentId;
  final List<MarkerData> markers;
  String? selectedPosition;
  final void Function(String, LatLng) onSelectLocation;

  PanelWidget({
    super.key,
    required this.markers,
    this.selectedPosition,
    required this.onSelectLocation,
    required this.documentId
  });

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  final FirestoreService firestoreService = FirestoreService();
  int? selectedIndex;
  String? selectedAddress;

  String? get finalSelectedAddress {
    if (widget.selectedPosition != null) {
      return widget.selectedPosition; // ใช้ตำแหน่งจากการปักหมุด
    }
    return selectedAddress; // ใช้ที่อยู่จากการเลือก radio
  }

  @override
  void didUpdateWidget(covariant PanelWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedPosition != null &&
        widget.selectedPosition != oldWidget.selectedPosition) {
      setState(() {
        selectedIndex = null;
        selectedAddress = widget.selectedPosition;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDragHandle(),
              const SizedBox(height: 5),
              const Text(
                'ตำแหน่งที่บันทึก:',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.getAddressesStream(
                    Provider.of<idAllAccountProvider>(context, listen: false).uid,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text("ไม่มีข้อมูลสถานที่ที่บันทึกไว้"),
                      );
                    }

                    var addresses = snapshot.data!.docs;
                    return ListView.builder(

                      padding: EdgeInsets.only(bottom: 4),
                      itemCount: addresses.length,
                      itemBuilder: (context, index) {
                        var data =
                            addresses[index].data() as Map<String, dynamic>;


                        String namePosition =
                            data['name'] ?? "ไม่มีชื่อสถานที่";
                        String nameAddress = data['address'] ?? "ไม่มีที่อยู่";
                        GeoPoint position = data['position'];
                        double lat = position.latitude; // Access latitude
                        double lng = position.longitude; // Access longitude
                        LatLng positionLatLng = LatLng(lat, lng);
                        int radioValue = index;

                        return Card(
                          color: Colors.white,
                          child: ListTile(
                            leading: Radio<int>(
                              value: radioValue,
                              groupValue: selectedIndex,
                              activeColor: Colors.green[700],
                              onChanged: (int? value) {
                                setState(() {
                                  selectedIndex = value;
                                  selectedAddress = nameAddress;
                                });

                                Future.delayed(Duration.zero, () {
                                  widget.onSelectLocation(
                                    nameAddress,
                                    positionLatLng,
                                  );
                                });
                              },
                            ),
                            title: Text(
                              namePosition,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'ที่อยู่: $nameAddress',
                              maxLines: 2,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 65,
          child: ElevatedButton(
            onPressed: () {
              final address = finalSelectedAddress;
              print('ที่อยู่ที่เลือก: $address');
              if (address != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailBookingPage(address: address,documentId: widget.documentId,),
                  ),
                );
              } else {
                // ถ้ายังไม่ได้เลือกที่อยู่
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('กรุณาเลือกตำแหน่ง')));
              }
            },
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Icon(
              Icons.navigate_next_sharp,
              size: 35,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDragHandle() => Center(
    child: Container(
      width: 36,
      height: 7,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
