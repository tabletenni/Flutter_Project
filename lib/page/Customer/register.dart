import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'package:intl/intl.dart';
import 'package:project/Data/customer.dart';
import 'package:project/page/Customer/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: BazierCurveRegister(),
                child: Container(
                  color: const Color.fromARGB(255, 25, 98, 47),
                  height: 270,
                ),
              ),
              Positioned(
                top: 50, // ปรับตำแหน่งให้อยู่ด้านบน
                left: 0,
                right: 0,
                child: ArcText(
                  text: 'REGISTER',
                  textStyle: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 5,
                  ),
                  radius: -220, // ขนาดของเส้นวงกลมที่ใช้ในการโค้งข้อความ
                  startAngleAlignment: StartAngleAlignment.center,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Text('Full name', style: TextStyle(fontSize: 20)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  child: TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      hintText: "Please enter your Full name",
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Text('Phone Number', style: TextStyle(fontSize: 20)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  child: TextFormField(
                    controller: _phoneNoController,
                    decoration: InputDecoration(
                      hintText: "Please enter your Phone Number",
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      counterText: '',
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your phone number";
                      } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return "Invalid phone number (must be 10 digits)";
                      }
                      return null;
                    },
                    maxLength: 10,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Text('Email', style: TextStyle(fontSize: 20)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Please enter your Email",
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      } else if (!RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                      ).hasMatch(value)) {
                        return "Invalid email format";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Text('Password', style: TextStyle(fontSize: 20)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  child: TextFormField(
                    controller: _passWordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Please enter your Password",
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 25, 98, 47),
              minimumSize: Size(270, 60),
            ),
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                // ถ้าผ่านการ validate
                String email = _emailController.text;
                String password = _passWordController.text;
                String fullName = _fullNameController.text;
                String phoneNo = _phoneNoController.text;

                // เรียกใช้ฟังก์ชันการลงทะเบียน
                Customer? user = await registerUser(
                  email,
                  password,
                  fullName,
                  phoneNo,
                );
                print(user);
                print('Email: $email');
                print('Password: $password');
                print('Full Name: $fullName');
                print('Phone Number: $phoneNo');
                
                if (user != null) {
                  _emailController.clear();
                  _passWordController.clear();
                  _fullNameController.clear();
                  _phoneNoController.clear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (builder) => LoginUserPage()),
                  );
                  
                } else {
                  print('Registration failed');
                }
              }
            },
            child: Text(
              'Sign up',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.only(left: 95),
            child: Row(
              children: [
                Text('Already have account?'),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (builder) => LoginUserPage()),
                    );
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.lightBlue[900]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<Customer?> registerUser(
  String email,
  String password,
  String fullName,
  String phoneNo,
) async {
  try {
    print('Starting registration...');

    // ตรวจสอบว่าอีเมลนี้มีการลงทะเบียนใน Firebase แล้วหรือไม่
    final signInMethods = await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(email);

    if (signInMethods.isNotEmpty) {
      print('This email is already registered');
      return null;
    }

    // สร้างผู้ใช้ใน Firebase Authentication
    final UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // รับข้อมูลผู้ใช้ที่สร้างใน Firebase
    User? user = userCredential.user;
    print(user);

    // เช็คว่าผู้ใช้ถูกสร้างสำเร็จหรือไม่
    if (user != null) {
      String uid = user.uid; // ใช้ UID จาก Firebase Authentication

      // สร้าง object ของ Customer
      Customer newCustomer = Customer(
        userId: uid, // ตั้งค่า userId เป็น UID ของ Firebase Authentication
        name: fullName,
        phoneNumber: phoneNo,
        email: email,
        password: password,
        typeacc: 'customer', // ค่าเริ่มต้นเป็น customer
        photo: 'https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png',
        addresses: [],
        bookingHistory: [],
      );

      // บันทึกข้อมูลผู้ใช้ลงใน Firestore และใช้ UID เป็น document ID
      await FirebaseFirestore.instance
          .collection('Customer')
          .doc(uid) // ใช้ UID เป็น document ID
          .set({
            'userId': uid, // บันทึก UID ไว้ใน field userId ด้วย
            'userName': newCustomer.name,
            'phoneNum': phoneNo,
            'userEmail': email,
            'typeacc': 'customer',
            'userPhoto': newCustomer.photo,
            // 'bookingHistory': [],
          });

      print('Data saved successfully! UserId: $uid');
      return newCustomer;
    } else {
      print('User creation failed');
      return null;
    }
  } catch (e) {
    print(e);

    // ตรวจสอบประเภทข้อผิดพลาดที่พบบ่อยจาก Firebase
    if (e is FirebaseAuthException) {
      if (e.code == 'email-already-in-use') {
        print('The email is already in use by another account.');
      } else if (e.code == 'weak-password') {
        print('The password is too weak. Please choose a stronger password.');
      } else {
        print('Registration failed. Please try again later.');
      }
    } else {
      print('Unexpected error: $e');
    }

    return null;
  }
}




class BazierCurveRegister extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height * 0.70); // เริ่มต้นจากมุมซ้าย

    // ส่วนโค้งเว้า (หลุม)
    path.quadraticBezierTo(
      size.width * 0.5, // จุดควบคุมให้อยู่กลางเส้น
      size.height * 1.3, // จุดควบคุมต่ำกว่าปกติ ทำให้เกิดหลุม
      size.width,
      size.height * 0.70,
    );
    path.lineTo(size.width, size.height * 0.70); // ข้างขวาสูงเท่ากับข้างซ้าย
    path.lineTo(size.width, 0); // ปิดเส้นขอบบน
    path.lineTo(0, 0); // ปิดเส้นขอบบนฝั่งซ้าย
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldCliper) {
    return true;
  }
}
