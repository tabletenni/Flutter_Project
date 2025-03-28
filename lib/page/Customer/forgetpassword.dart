import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForGetPasswordPage extends StatefulWidget {
  const ForGetPasswordPage({super.key});

  @override
  State<ForGetPasswordPage> createState() => _ForGetPasswordPageState();
}

class _ForGetPasswordPageState extends State<ForGetPasswordPage> {
  final _formKey = GlobalKey<FormState>(); // ใช้เช็คค่า input
  final TextEditingController _emailController =
      TextEditingController(); // รับค่าจาก TextFormField

  Future<void> resetPassword() async {
    if (_formKey.currentState!.validate()) {
      // ตรวจสอบว่ากรอกอีเมลถูกต้องหรือไม่
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "ลิงก์เปลี่ยนรหัสผ่านถูกส่งไปที่ ${_emailController.text}",
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("เกิดข้อผิดพลาด: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ปุ่มปิด อยู่มุมซ้ายบน
          Positioned(
            top: 70,
            left: 20,
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 25, 98, 47),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),

          // จัดให้ Form และปุ่มอยู่ตรงกลาง
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Enter your email to reset password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),

                    // ช่องกรอกอีเมล
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Color.fromARGB(
                            255,
                            25,
                            98,
                            47,
                          ), // เปลี่ยนสีของ labelText ที่แสดงใน TextFormField
                        ),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                        // กำหนดสีกรอบเมื่อไม่ได้โฟกัส
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ), // สีของกรอบเมื่อไม่ได้โฟกัส
                        ),
                        // กำหนดสีกรอบเมื่อโฟกัส
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 25, 98, 47),
                          ), // สีของกรอบเมื่อโฟกัส
                        ),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "กรุณากรอกอีเมล";
                        } else if (!RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                        ).hasMatch(value)) {
                          return "กรุณากรอกอีเมลให้ถูกต้อง";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // ปุ่ม Reset Password
                    ElevatedButton(
                      onPressed: resetPassword,
                      child: Text("Reset Password", style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 25, 98, 47),
                        minimumSize: Size(100, 50)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
