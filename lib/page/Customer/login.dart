import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project/Data/customer.dart' show Customer;
import 'package:project/page/Admin/homeAdmin.dart';
import 'package:project/page/Customer/forgetpassword.dart';
import 'package:project/page/Customer/customerHome.dart';
import 'package:project/page/Customer/register.dart';
import 'package:project/page/Employee/employeeHome.dart';
import 'package:project/provider/authProvider.dart';
import 'package:project/service/firestore.dart';
import 'package:provider/provider.dart';

// ขาดเงา ตรง curve
class LoginUserPage extends StatefulWidget {
  const LoginUserPage({super.key});

  @override
  State<LoginUserPage> createState() => _LoginUserPageState();
}

class _LoginUserPageState extends State<LoginUserPage> {
  DateTime date = DateTime.now();
  FirestoreService firestoreService =
      FirestoreService(); // สร้าง instance ของ FirestoreService
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passWordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: BazierCurve(),
                child: Container(
                  color: const Color.fromARGB(255, 25, 98, 47),
                  height: 400,
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 360,
                  width: 360,
                ),
              ),
              Positioned(
                top: 140, // ปรับตำแหน่งให้อยู่ด้านบน
                left: 0,
                right: 0,

                child: ArcText(
                  text: 'WELCOME BACK',
                  textStyle: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade300,
                    letterSpacing: 5,
                  ),
                  radius: -220, // ขนาดของเส้นวงกลมที่ใช้ในการโค้งข้อความ
                  startAngleAlignment: StartAngleAlignment.center,
                ),
              ),
            ],
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 40, left: 40),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Please enter your email",
                      border: InputBorder.none, // ไม่มีเส้นขอบ
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0), // ขอบมน
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ), // ให้เส้นขอบโปร่งใส
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0), // ขอบมน
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ), // ให้เส้นขอบโปร่งใส
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      } else if (!RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      ).hasMatch(value)) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 40, left: 40),
                  child: TextFormField(
                    controller: _passWordController,
                    obscureText: true, // ซ่อนข้อความเมื่อพิมพ์
                    decoration: InputDecoration(
                      hintText: "Please enter your password",
                      border: InputBorder.none, // ไม่มีเส้นขอบ
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0), // ขอบมน
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ), // ให้เส้นขอบโปร่งใส
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13.0), // ขอบมน
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ), // ให้เส้นขอบโปร่งใส
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null; // ถ้าผ่านการตรวจสอบ ให้คืนค่า null
                    },
                  ),
                ),
                SizedBox(height: 1),
                Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => ForGetPasswordPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Forget password',
                        style: TextStyle(color: Colors.lightBlue[900]),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var email = _emailController.text;
                      var password = _passWordController.text;

                      // เรียกใช้ฟังก์ชัน login
                      bool loginSuccess = await login(email, password);

                      if (loginSuccess) {
                        // สามารถดำเนินการต่อไปได้ถ้าการเข้าสู่ระบบสำเร็จ
                        print('Login success');
                      } else {
                        // แจ้งเตือนหรือดำเนินการเพิ่มเติมหากเข้าสู่ระบบไม่สำเร็จ
                        print('Login failed');
                      }
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 25, 98, 47),
                    minimumSize: Size(270, 60),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 57, left: 57),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: Size(200, 60),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    onPressed: signInWithGoogle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/googleicon.png',
                          height: 30,
                          width: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Sing in with Google',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 65),
                  child: Row(
                    children: [
                      Text('Don’t have any account ?'),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Register Now',
                          style: TextStyle(color: Colors.lightBlue[900]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return null; // ผู้ใช้กดยกเลิกการล็อกอิน
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final String userId =
          userCredential.user?.uid ?? ''; // ใช้ uid จาก Firebase
      final String userEmail = googleUser.email;
      final String userName = googleUser.displayName ?? '';
      final String userPhoto =
          'https://static.vecteezy.com/system/resources/previews/019/879/186/non_2x/user-icon-on-transparent-background-free-png.png';

      var userProvider = Provider.of<idAllAccountProvider>(context, listen: false);

      print('userEmail: $userEmail');
      print('userId (UID): $userId');

      // ตรวจสอบว่า uid นี้มีอยู่ใน Firestore แล้วหรือไม่
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('Customer')
              .doc(userId)
              .get();

      if (!userDoc.exists) {
        // ถ้าไม่มีข้อมูลใน Firestore ให้สร้างเอกสารใหม่โดยใช้ uid เป็น docId
        Customer newCustomer = Customer(
          userId: userId,
          name: userName,
          phoneNumber: '',
          email: userEmail,
          password: '',
          typeacc: 'customer',
          addresses: [],
          photo: userPhoto,
          bookingHistory: [],
        );

        await FirebaseFirestore.instance.collection('Customer').doc(userId).set(
          {
            'userId': newCustomer.userId, // ใช้ uid เป็น userId
            'userName': newCustomer.name,
            'phoneNum': '',
            'userEmail': newCustomer.email,
            'userPassword': newCustomer.email,
            'userPhoto': newCustomer.photo,
            'typeacc': newCustomer.typeacc,
          },
        );

        userProvider.setUid(userId);
      } else {
        // ถ้ามีข้อมูลแล้ว ให้ตั้งค่า docId ใน UserProvider
        userProvider.setUid(userId);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );

      return userCredential.user;
    } catch (e) {
      print('Error during Google sign in: $e');
      return null;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = credential.user;
      String userId = user?.uid ?? "";

      print("User ID: ${user?.uid}");
      if (user != null) {
        var userProvider = Provider.of<idAllAccountProvider>(context, listen: false);
        userProvider.setUid(userId);
        String? userType = await firestoreService.getUserType(user.uid);
        print("User Type: $userType");
        if (userType != null) {
          // 🔹 นำทางไปยัง Home ตามประเภท
          Widget homePage;
          if (userType == 'customer') {
            homePage = HomePage();
          } else if (userType == 'Employee') {
            homePage = employeeHomePage();
          } else if (userType == 'Admin') {
            homePage = HomeAdminPage();
          } else {
            homePage = HomePage();
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => homePage),
          );
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("ไม่พบข้อมูลบัญชีในระบบ"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      print("Firebase Error Code: ${e.code}"); // Debugging

      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'ไม่พบบัญชีผู้ใช้นี้';
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errorMessage = 'อีเมล หรือรหัสผ่านไม่ถูกต้อง';
      } else {
        errorMessage = 'เกิดข้อผิดพลาด กรุณาเข้าสู่ระบบภายหลัง';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
    return false;
  }
}

class BazierCurve extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height * 0.68); // เริ่มต้นจากมุมซ้าย

    // ส่วนโค้งเว้า (หลุม)
    path.quadraticBezierTo(
      size.width * 0.5, // จุดควบคุมให้อยู่กลางเส้น
      size.height * 1.1, // จุดควบคุมต่ำกว่าปกติ ทำให้เกิดหลุม
      size.width,
      size.height * 0.68,
    );
    path.lineTo(size.width, size.height * 0.68); // ข้างขวาสูงเท่ากับข้างซ้าย
    path.lineTo(size.width, 0); // ปิดเส้นขอบบน
    path.lineTo(0, 0); // ปิดเส้นขอบบนฝั่งซ้าย

    // path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldCliper) {
    return true;
  }
}
