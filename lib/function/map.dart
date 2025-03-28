import 'dart:convert';

import 'package:http/http.dart' as http;

class GeocodingService {
 
  // ฟังก์ชันแปลงพิกัด (latitude, longitude) เป็นที่อยู่
  static Future<String> getAddressFromLatLng(double latitude, double longitude) async {
     String apiKey = 'AIzaSyAtiVZyXeDK7CGXAbooOJojX4jBZEMHPIw'; // ใส่ API Key ของคุณที่นี่
    final String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final address = data['results'][0]['formatted_address'];
        return address ?? 'ไม่พบข้อมูลที่อยู่';
      } else {
        return 'ไม่พบที่อยู่';
      }
    } else {
      return 'ไม่สามารถแปลงที่อยู่ได้';
    }
  }
static Future<Map<String, double>?> convertAddressToLatLng(String address) async {
   String apiKey = 'AIzaSyAtiVZyXeDK7CGXAbooOJojX4jBZEMHPIw'; // ใส่ API Key ของคุณที่นี่
    final String encodedAddress = Uri.encodeComponent(address);
    final String url = "https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "OK") {
          return {
            "latitude": data["results"][0]["geometry"]["location"]["lat"],
            "longitude": data["results"][0]["geometry"]["location"]["lng"],
          };
        }
      }
      return null;
    } catch (e) {
      print("❌ Error: $e");
      return null;
    }
  }

  
  
}