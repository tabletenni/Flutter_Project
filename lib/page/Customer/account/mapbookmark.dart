import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:project/function/map.dart';
import 'package:project/provider/authProvider.dart';
import 'package:project/service/firestore.dart';
import 'package:provider/provider.dart';

class MapBookMark extends StatefulWidget {
  const MapBookMark({super.key});

  @override
  State<MapBookMark> createState() => _MapBookMarkState();
}

class _MapBookMarkState extends State<MapBookMark> {
  Set<Marker> marker = {}; // ตนใน gg map
  static const LatLng _pGoolgePlex = LatLng(13.736717, 100.523186);
  late GoogleMapController googleMapController;
  final TextEditingController searchController =
      TextEditingController(); // หาสถานที่
  LatLng _markerPosition = LatLng(0, 0);
  List<Prediction> predictions = []; // ลิสต์สถานที่แนะนำที่จะแสดง
  String? _address;
  String ggAPI = 'AIzaSyAtiVZyXeDK7CGXAbooOJojX4jBZEMHPIw';

  final TextEditingController nameController =
      TextEditingController(); // สำหรับชื่อสถานที่
  List<Map<String, dynamic>> savedAddresses =
      []; // เก็บที่อยู่พร้อมชื่อและตำแหน่ง

  final FirestoreService firestoreService = FirestoreService();
  LatLng? position_tap;
  final _formKey = GlobalKey<FormState>();


  void _selectLocationFromMap(LatLng position) async {
    String address = await GeocodingService.getAddressFromLatLng(
      position.latitude,
      position.longitude,
    );

    setState(() {
      _address = address; // ใช้ค่าที่ได้จาก Future
      print('address: $_address');
      _markerPosition = position;
      marker.clear(); // ลบ Marker เก่า
      marker.add(
        Marker(
          markerId: MarkerId('Current Location'),
          position: position,
          infoWindow: InfoWindow(
            title: 'สถานที่: $_address',
          ), // แสดงที่อยู่ที่ได้รับ
          consumeTapEvents: true,
        ),
      );
    });
  }

  Future<Position> currentPosition() async {
    bool serviceEnable;
    LocationPermission permission;

    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      return Future.error('Location servicea are disable');
    }
    // check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location denied permanently');
    }

    Position position = await Geolocator.getCurrentPosition();
    double lat = position.latitude;
    double lng = position.longitude;

    print("พิกัด: $lat, $lng");

    // แปลงพิกัดเป็นที่อยู่
    String _address = await GeocodingService.getAddressFromLatLng(lat, lng);
    print(_address);
    return position;
  }

  // ฟังก์ชันสำหรับคลิกที่สถานที่แนะนำ
  void _updateMarkerPosition(Prediction prediction) async {
    // ใช้ Geocoding API เพื่อแปลงชื่อสถานที่จาก description เป็น latitude และ longitude
    try {
      List<Location> locations = await locationFromAddress(
        prediction.description ?? "", // แปลงจาก สถานที่ -> lat, lng
      );
      print('location:$locations');
      if (locations.isNotEmpty) {
        setState(() {
          _markerPosition = LatLng(
            locations[0].latitude,
            locations[0].longitude,
          );
          _address = prediction.description;
          // ลบสถานที่ที่ถูกเลือกออกจากรายการ predictions
          predictions.remove(prediction); // ลบ prediction ที่ถูกเลือก
        });

        // เคลื่อนกล้องไปยังตำแหน่งใหม่
        googleMapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _markerPosition, zoom: 15),
          ),
        );

        // ลบ Marker เก่าและเพิ่ม Marker ใหม่
        marker.clear(); // ลบ Marker เดิม
        marker.add(
          Marker(
            markerId: const MarkerId("This is my Location"),
            position: _markerPosition,
            infoWindow: InfoWindow(
              title: 'สถานที ${_address.toString()}',
            ), // แสดงที่อยู่ที่ได้รับ
          ),
        );

        setState(() {});
      }
    } catch (e) {
      print("Error getting location for address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final docId = Provider.of<idAllAccountProvider>(context).uid;
    return Scaffold(
      appBar: AppBar(title: Text('บันทึกสถานที่')),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            // Use Positioned.fill to make the GoogleMap take full space
            child: GoogleMap(
              markers: marker,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _pGoolgePlex,
                zoom: 13,
              ),

              onTap: (LatLng tappedLocation) {
                // เมื่อผู้ใช้คลิกที่ตำแหน่งในแผนที่
                _selectLocationFromMap(tappedLocation);
                position_tap = tappedLocation;
              },
            ),
          ),

          Positioned(
            top: 20,
            left: 15,
            right: 15,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // ทำให้ช่องค้นหามองเห็นชัด
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: searchController,
                googleAPIKey: ggAPI,
                debounceTime: 800,
                countries: ['TH', 'US'],
                isLatLngRequired: true,
                placeType: PlaceType.address,
                inputDecoration: InputDecoration(
                  hintText: 'ค้นหาสถานที่',
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                ),
                itemBuilder: (context, index, Prediction prediction) {
                  print(
                    "Prediction description: ${prediction.description ?? 'null'}",
                  );
                  return GestureDetector(
                    onTap: () {
                      // เมื่อคลิกที่สถานที่ที่แนะนำ
                      String _address = prediction.description.toString();
                      print("Clicked on: ${prediction.description}");
                      _updateMarkerPosition(prediction);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.blue),
                          SizedBox(width: 7),
                          Expanded(
                            child: Text('${prediction.description ?? ""}'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 70,
            right: 20,
            child: FloatingActionButton(
              heroTag: 'current_location_button',
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigo,
              onPressed: () async {
                Position position = await currentPosition();
                googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(position.latitude, position.longitude),
                      zoom: 13,
                    ),
                  ),
                );
                marker.clear();
                marker.add(
                  Marker(
                    markerId: const MarkerId("This is my Location"),
                    position: LatLng(position.latitude, position.longitude),
                  ),
                );
                String address = await GeocodingService.getAddressFromLatLng(
                  position.latitude,
                  position.longitude,
                );
                setState(() {
                  _address = address;
                  ;
                });
              },
              child: Icon(Icons.location_searching_rounded),
            ),
          ),
          Positioned(
            bottom: 70,
            left: 20,
            child: FloatingActionButton(
              heroTag: 'bookmarker_location',
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.indigo,
              onPressed: () async {
                String address = await GeocodingService.getAddressFromLatLng(
                  position_tap!.latitude,
                  position_tap!.longitude,
                );
                showDialog(
                  context: context,

                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("ข้อมูลตำแหน่ง"),
                      content: SizedBox(
                        width: 300,
                        child: Form(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                address ??
                                    "ที่อยู่ไม่พร้อมใช้งาน", // ถ้า _address เป็น null แสดงข้อความนี้แทน
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 3),
                              TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  labelText: 'ชื่อสถานที่',
                                  hintText: 'กรุณากรอกชื่อสถานที่',
                                  border: UnderlineInputBorder(), // ขีดเส้นใต้
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ), // สีและความหนาของขีดเส้นใต้เมื่อมีการโฟกัส
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ), // สีและความหนาของขีดเส้นใต้ในสถานะปกติ
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ), // สีของ label
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ), // สีของ hint
                                ),
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ), // ปรับสีข้อความที่กรอก
                              ),
                            ],
                          ),
                        ),
                      ),

                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // ปิด dialog
                          },
                          child: Text('ยกเลิก'),
                        ),
                        TextButton(
                          child: Text("เพิ่ม"),
                          onPressed: () {
                            String _nameAddress = nameController.text;
                            firestoreService.saveAddress(
                              docId,
                              _nameAddress,
                              address,
                              position_tap!,
                            );
                            Navigator.pop(context);
                            nameController.clear();
                          },
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // มุมโค้ง
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.add_location_alt_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
