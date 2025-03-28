class Employee {
  final String id; // ✅ เพิ่ม documentId
  String name;
  final String gender;
  String email;
  String phoneNumber;
  final String serviceType;
  final String expertiseLevels;
  final String imageUrl;
  final String password;
  final String typeacc;

  Employee({
    required this.id, // ✅ เพิ่ม documentId
    required this.name,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    required this.serviceType,
    required this.expertiseLevels,
    required this.imageUrl,
    required this.password,
    required this.typeacc,
  });

  // ✅ แปลงเป็น JSON เพื่อบันทึกลง Firestore
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "gender": gender,
      "email": email,
      "phoneNumber": phoneNumber,
      "serviceType": serviceType,
      "expertiseLevels": expertiseLevels,
      "imageUrl": imageUrl,
      "password": password,
      "typeacc": typeacc,
    };
  }

  // ✅ แปลงจาก Firestore JSON มาเป็น Object (รองรับ documentId)
  factory Employee.fromJson(Map<String, dynamic> json, String documentId) {
    return Employee(
      id: documentId, // ✅ ดึง doc.id จาก Firestore
      name: json["name"] ?? "",
      gender: json["gender"] ?? "",
      email: json["email"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      serviceType: json["serviceType"] ?? "",
      expertiseLevels: json["expertiseLevels"] ?? "",
      imageUrl: json["imageUrl"] ?? "", // กำหนดค่าเริ่มต้นเป็น "" ถ้าเป็น null
      password: json["password"] ?? "", // กำหนดค่าเริ่มต้นเป็น "" ถ้าเป็น null
      typeacc: json["typeacc"] ?? ""
    );
  }
}