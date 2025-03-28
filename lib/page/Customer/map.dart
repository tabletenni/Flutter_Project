import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:project/Data/marker_data.dart'; // Import ที่นี่
import 'package:project/function/map.dart';
import 'package:project/widget/panel_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapPage extends StatefulWidget {
  final String documentId;
  const MapPage({super.key, required this.documentId});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool isMapSelected = true;
  String ggAPI = 'AIzaSyAtiVZyXeDK7CGXAbooOJojX4jBZEMHPIw';
  static const LatLng _pGoolgePlex = LatLng(13.736717, 100.523186);
  LatLng _markerPosition = LatLng(0, 0);
  final TextEditingController searchController =
      TextEditingController(); // หาสถานที่
  List<Prediction> predictions = []; // ลิสต์สถานที่แนะนำที่จะแสดง
  bool _isPanelVisible = true; // ตัวแปรควบคุมการแสดง FloatingActionButton
  String? _address;
  late GoogleMapController googleMapController;
  Set<Marker> marker = {}; // ตนใน gg map

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
          ),
        );

        setState(() {});
      }
    } catch (e) {
      print("Error getting location for address: $e");
    }
  }

  // ฟังก์ชันสำหรับเลือกตำแหน่งจาก GoogleMap
  void _selectLocationFromMap(LatLng position) async {
    String address = await GeocodingService.getAddressFromLatLng(
      position.latitude,
      position.longitude,
    );

    setState(() {
      isMapSelected = true; // เปลี่ยนสถานะเป็นเลือกจาก GoogleMap
      _address = address; // ใช้ค่าที่ได้จาก Future
      print('address: $_address');
      _markerPosition = position;
      marker.clear(); // ลบ Marker เก่า
      marker.add(
        Marker(markerId: MarkerId('Current Location'), position: position),
      );
    });
  }

  // ฟังก์ชันสำหรับเลือกตำแหน่งจาก SlidingUpPanel
  void _selectLocationFromPanel(String address, LatLng position) {
    setState(() {
      isMapSelected = false; // เปลี่ยนสถานะการเลือกเป็น SlidingUpPanel
      _address = address;
      _markerPosition = position; // อัปเดตตำแหน่งที่เลือกจาก SlidingUpPanel
      marker.clear(); // ลบ Marker เก่า
      marker.add(Marker(markerId: MarkerId(address), position: position));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightClosed =
        MediaQuery.of(context).size.height * 0.1; // panel ที่แสดงให้เห็น
    final panelHeightOpne =
        MediaQuery.of(context).size.height * 0.5; // panel ที่แสดงให้เห็น
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'เลือกสถานที่',
          style: TextStyle(color: Colors.white),
        ), // ✅ อัปเดต title ตาม index
        backgroundColor: const Color.fromARGB(255, 25, 98, 47),

        elevation: 4.0,
        shadowColor: Colors.black.withOpacity(1),
      ),
      backgroundColor: Color.fromARGB(255, 243, 247, 222),
      body: Stack(
        children: [
          SlidingUpPanel(
            minHeight: panelHeightClosed,
            maxHeight: panelHeightOpne,
            parallaxEnabled: true,
            parallaxOffset: .5,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            panelBuilder:
                (ScrollController controller) => PanelWidget(
                  markers: markers_list,
                  selectedPosition: _address ?? '',
                  onSelectLocation: _selectLocationFromPanel,
                  documentId: widget.documentId,
                ),
            onPanelSlide: (position) {
              setState(() {
                _isPanelVisible = position < 0.1;
              });
            },
            body: GoogleMap(
              markers: marker,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _pGoolgePlex,
                zoom: 13,
              ),
              onTap: (LatLng position) {
                // เมื่อผู้ใช้คลิกที่ตำแหน่งในแผนที่
                _selectLocationFromMap(position);
              },
            ),
          ),

          /// 🔍 **ช่องค้นหา อยู่บนสุด**
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
          if (_isPanelVisible)
            Positioned(
              bottom: 120,
              right: 20,
              child: FloatingActionButton(
                heroTag: 'current_location_button',
                backgroundColor: Color.fromARGB(255, 25, 98, 47),
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
                  });
                },
                child: Icon(
                  Icons.location_searching_rounded,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
