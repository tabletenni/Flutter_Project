import 'package:flutter/material.dart';
import 'package:project/page/Customer/customerHome.dart';

class PaySuccessPage extends StatelessWidget {
  const PaySuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 247, 222),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 170),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(255, 30, 91, 48),
              ),
              child: Icon(Icons.check, color: Colors.white, size: 100),
            ),
            SizedBox(height: 10),
            Text('Successful !', style: TextStyle(fontSize: 35)),
            SizedBox(height: 10),
            Text(
              'Your payment was don successfully.',
              style: TextStyle(fontSize: 19, color: Colors.blueGrey),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color.fromARGB(255, 30, 91, 48),
                minimumSize: Size(170, 50),
                side: BorderSide(
                  color: Color.fromARGB(255, 30, 91, 48), // สีขอบ
                  width: 2.0, // ความหนาของขอบ
                ),
              ),
              child: Text(
                'OK',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
