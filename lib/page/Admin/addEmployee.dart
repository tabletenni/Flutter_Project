// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:test/model/Employee.dart';
// import 'package:test/screen/listEmployee.dart';
// import 'package:test/services/firestore.dart';

// class AddEmployeePage extends StatefulWidget {
//   const AddEmployeePage({super.key});

//   @override
//   State<AddEmployeePage> createState() => _AddEmployeePageState();
// }

// class _AddEmployeePageState extends State<AddEmployeePage> {
//   final FirestoreService _firestoreService = FirestoreService(); // ✅ ใช้ FirestoreService
//   final _formKey = GlobalKey<FormState>();

//   String? selectedService;
//   String? selectedExpertise;
//   String? selectedGender;
//   File? _imageFile;

//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   final List<String> services = ['ทำความสะอาด', 'ดูแลสวน', 'ดูแลผู้สูงอายุ', 'ดูแลสัตว์เลี้ยง'];
//   final List<String> expertiseLevels = ['เริ่มต้น', 'ปานกลาง', 'ชำนาญ'];
//   final List<String> genders = ['ชาย', 'หญิง'];

//   /// ✅ เพิ่มข้อมูลพนักงานเข้า Firestore
//   Future<void> _addEmployee() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState?.save();

//       String imageUrl = await _firestoreService.uploadImage(_imageFile);

//       Employee newEmployee = Employee(
//         id: "",
//         name: nameController.text,
//         gender: selectedGender ?? "",
//         email: emailController.text,
//         phoneNumber: phoneController.text,
//         serviceType: selectedService ?? "",
//         expertiseLevels: selectedExpertise ?? "",
//         imageUrl: imageUrl,
//         password: passwordController.text,
//       );

//       try {
//         await _firestoreService.addEmployee(newEmployee);
//         if (!mounted) return;

//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(content: Text("เพิ่มพนักงานสำเร็จ!")));

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const EmployeeListPage()),
//         );

//         _formKey.currentState?.reset();
//         setState(() {
//           selectedGender = null;
//           selectedService = null;
//           selectedExpertise = null;
//           _imageFile = null;
//         });
//       } catch (error) {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text("เกิดข้อผิดพลาด: $error")));
//       }
//     }
//   }

//   /// ✅ เลือกภาพจากแกลเลอรี
//   Future<void> _pickImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         title: const Text('เพิ่มพนักงาน', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.blueGrey[700],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Center(
//                 child: Stack(
//                   children: [
//                     ClipOval(
//                       child: Container(
//                         width: 120,
//                         height: 120,
//                         decoration: BoxDecoration(color: Colors.grey[300]),
//                         child: _imageFile != null
//                             ? Image.file(_imageFile!, fit: BoxFit.cover)
//                             : const Icon(Icons.person_outline,
//                                 size: 50, color: Colors.white),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: InkWell(
//                         onTap: _pickImage,
//                         child: Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.black,
//                             border: Border.all(color: Colors.white, width: 2),
//                           ),
//                           child: const Icon(Icons.camera_alt,
//                               color: Colors.white, size: 18),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               buildSectionTitle("ข้อมูลส่วนตัว"),
//               buildInputField(hint: "ชื่อ-นามสกุล", controller: nameController),
//               SizedBox(height: 20,),
//               buildDropdownField(
//                   hint: "เพศ",
//                   items: genders,
//                   value: selectedGender,
//                   onChanged: (val) => setState(() => selectedGender = val)),
//               SizedBox(height: 20,),
//               buildInputField(hint: "รหัสผ่าน", controller: passwordController),
//               buildSectionTitle("ช่องทางการติดต่อ"),
//               buildInputField(
//                   hint: "เบอร์โทร", controller: phoneController, type: TextInputType.phone, maxLength: 10),
//               SizedBox(height: 20,),
//               buildInputField(
//                   hint: "อีเมล", controller: emailController, type: TextInputType.emailAddress),
//               buildSectionTitle("ข้อมูลการทำงาน"),
//               buildDropdownField(
//                   hint: "ประเภทงานบริการ",
//                   items: services,
//                   value: selectedService,
//                   onChanged: (val) => setState(() => selectedService = val)),
//               SizedBox(height: 20,),
//               buildDropdownField(
//                   hint: "ระดับความชำนาญ",
//                   items: expertiseLevels,
//                   value: selectedExpertise,
//                   onChanged: (val) => setState(() => selectedExpertise = val)),
//               const SizedBox(height: 30),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _addEmployee,
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueGrey[700],
//                       padding: const EdgeInsets.symmetric(vertical: 16)),
//                   child: const Text('ยืนยัน',
//                       style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget buildInputField(
//     {required String hint,
//     required TextEditingController controller,
//     TextInputType type = TextInputType.text,
//     int? maxLength}) {
//   return TextFormField(
//     controller: controller,
//     keyboardType: type,
//     maxLength: maxLength,
//     decoration: InputDecoration(
//       fillColor: Colors.white,
//       filled: true,
//       hintText: hint,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       counterText: "",
//     ),
//     validator: (value) {
//       if (value == null || value.isEmpty) {
//         return 'กรุณากรอก $hint';
//       }
//       if (hint == 'เบอร์โทร') {
//         if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
//           return 'เบอร์โทรศัพท์ต้องเป็นตัวเลข 10 หลัก';
//         }
//       }
//       if (hint == 'ชื่อ-นามสกุล') {
//         if (!RegExp(r'^[a-zA-Zก-ฮ\s]+$').hasMatch(value)) {
//           return 'ชื่อ-นามสกุลต้องเป็นตัวอักษรเท่านั้น';
//         }
//       }
//       if (hint == 'อีเมล') {
//         if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
//             .hasMatch(value)) {
//           return 'รูปแบบอีเมลไม่ถูกต้อง';
//         }
//       }
//       return null;
//     },
//   );
// }

// Widget buildDropdownField(
//     {required String hint,
//     required List<String> items,
//     required String? value,
//     required void Function(String?) onChanged}) {
//   return DropdownButtonFormField<String>(
//     value: value,
//     decoration: InputDecoration(
//       fillColor: Colors.white,
//       hintText: hint,
//       filled: true,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//     ),
//     items: items
//         .map((item) => DropdownMenuItem(value: item, child: Text(item)))
//         .toList(),
//     onChanged: onChanged,
//     validator: (value) =>
//         (value == null || value.isEmpty) ? 'กรุณาเลือก $hint' : null,
//   );
// }

// Widget buildSectionTitle(String title) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 10),
//     child: Text(
//       title,
//       style: const TextStyle(
//           fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
//     ),
//   );
// }

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/page/Admin/listEmployee.dart';
import 'package:project/page/Admin/model/employee.dart';


class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  final CollectionReference _employeeCollection =
      FirebaseFirestore.instance.collection("Employee");
  

  String? selectedService;
  String? selectedExpertise;
  String? selectedGender;
  File? _imageFile; // รูปที่ผู้ใช้เลือก

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final List<String> services = [
    'ทำความสะอาด',
    'ดูแลสวน',
    'ดูแลผู้สูงอายุ',
    'ดูแลสัตว์เลี้ยง'
  ];
  final List<String> expertiseLevels = ['เริ่มต้น', 'ปานกลาง', 'ชำนาญ'];
  final List<String> genders = ['ชาย', 'หญิง'];

  /// ✅ ฟังก์ชันอัปโหลดรูปเข้า Firebase Storage หรือใช้ default_profile.png
  Future<String> _uploadImage(File? imageFile, String uid) async {
    try {
      if (imageFile == null) {
        // ใช้ default_profile.png จาก Firebase Storage
       return 'https://cdn-icons-png.flaticon.com/512/9356/9356874.png';

      }

      // อัปโหลดรูปไปยัง Storage
      String filePath = 'employee/profile/$uid.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(filePath);
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint("เกิดข้อผิดพลาดในการอัปโหลดรูปภาพ: $e");
      return "";
    }
  }

  /// ✅ ฟังก์ชันสมัครพนักงานใหม่ใน Firebase Authentication และ Firestore
  Future<void> _addEmployee() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      try {
        // ✅ 1. สมัครสมาชิกพนักงานใน Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        String uid = userCredential.user!.uid;

        // ✅ 2. อัปโหลดรูปโปรไฟล์ (ถ้ามี)
        String imageUrl = await _uploadImage(_imageFile, uid);

        // ✅ 3. บันทึกข้อมูลพนักงานลง Firestore
        Employee newEmployee = Employee(
          id: uid, // ใช้ UID ของ Firebase Authentication
          name: nameController.text,
          gender: selectedGender ?? "",
          email: emailController.text,
          phoneNumber: phoneController.text,
          serviceType: selectedService ?? "",
          expertiseLevels: selectedExpertise ?? "",
          imageUrl: imageUrl,
          password: passwordController.text, // **ไม่ควรบันทึกรหัสผ่านลง Firestore**
          typeacc: "employee"
        );

        await _employeeCollection.doc(uid).set(newEmployee.toJson());

        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("เพิ่มพนักงานสำเร็จ!")));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EmployeeListPage()),
        );

        _formKey.currentState?.reset();
        setState(() {
          selectedGender = null;
          selectedService = null;
          selectedExpertise = null;
          _imageFile = null;
        });
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("เกิดข้อผิดพลาด: ${e.message}")));
      }
    }
  }

  /// ฟังก์ชันเลือกภาพจากแกลเลอรี
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title:
            const Text('เพิ่มพนักงาน', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(color: Colors.grey[300]),
                        child: _imageFile != null
                            ? Image.file(_imageFile!, fit: BoxFit.cover)
                            : const Icon(Icons.person_outline,
                                size: 50, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _pickImage, // กดเพื่อเลือกรูปภาพจากแกลเลอรี
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              buildSectionTitle("ข้อมูลส่วนตัว"),
              buildInputField(hint: "ชื่อ-นามสกุล", controller: nameController),
              const SizedBox(height: 10),
              buildDropdownField(
                  hint: "เพศ",
                  items: genders,
                  value: selectedGender,
                  onChanged: (val) => setState(() => selectedGender = val)),
              const SizedBox(height: 10),
              buildSectionTitle("ข้อมูลการติดต่อ"),
              buildInputField(hint: "รหัสผ่าน", controller: passwordController),
              const SizedBox(height: 10),
              buildInputField(hint: "อีเมล", controller: emailController),
              const SizedBox(height: 10),
              buildInputField(hint: "เบอร์โทรศัพท์", controller: phoneController),
              buildSectionTitle("ข้อมูลการทำงาน"),
              buildDropdownField(
                  hint: "ประเภทงานบริการ",
                  items: services,
                  value: selectedService,
                  onChanged: (val) => setState(() => selectedService = val)),
              const SizedBox(height: 10),
              buildDropdownField(
                  hint: "ระดับความชำนาญ",
                  items: expertiseLevels,
                  value: selectedExpertise,
                  onChanged: (val) => setState(() => selectedExpertise = val)),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addEmployee,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[700],
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('ยืนยัน',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildInputField(
    {required String hint,
    required TextEditingController controller,
    TextInputType type = TextInputType.text,
    int? maxLength}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    maxLength: maxLength,
    decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      counterText: "",
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'กรุณากรอก $hint';
      }
      if (hint == 'เบอร์โทร') {
        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
          return 'เบอร์โทรศัพท์ต้องเป็นตัวเลข 10 หลัก';
        }
      }
      if (hint == 'ชื่อ-นามสกุล') {
        if (!RegExp(r'^[a-zA-Z\u0E00-\u0E7F]+(?:\s[a-zA-Z\u0E00-\u0E7F]+)*$')
            .hasMatch(value.trim())) {
          return 'ชื่อ-นามสกุลต้องเป็นตัวอักษรเท่านั้น';
        }
      }

      if (hint == 'อีเมล') {
        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(value)) {
          return 'รูปแบบอีเมลไม่ถูกต้อง';
        }
      }
      return null;
    },
  );
}

Widget buildDropdownField(
    {required String hint,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged}) {
  return DropdownButtonFormField<String>(
    value: value,
    decoration: InputDecoration(
      fillColor: Colors.white,
      hintText: hint,
      filled: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    ),
    items: items
        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
        .toList(),
    onChanged: onChanged,
    validator: (value) =>
        (value == null || value.isEmpty) ? 'กรุณาเลือก $hint' : null,
  );
}

Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(
      title,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
    ),
  );
}


