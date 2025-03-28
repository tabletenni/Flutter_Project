import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project/page/Customer/allreview.dart';
import 'package:project/page/Customer/map.dart';
import 'package:project/provider/authProvider.dart';
import 'package:project/service/firestore.dart';
import 'package:project/widget/witgetComment.dart';
import 'package:provider/provider.dart';

class EmployeePage extends StatefulWidget {
  final String documentId;
  String name;
  String image;
  String type;
  EmployeePage({
    super.key,
    required this.documentId,
    required this.name,
    required this.image,
    required this.type,
  });

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  late Stream<String> imageStream;

  FirestoreService firestoreService = FirestoreService();
  final TextEditingController _commentController = TextEditingController();
  double rating = 0.0;

  @override
  Widget build(BuildContext context) {
    final docId = Provider.of<idAllAccountProvider>(context).uid;
    imageStream = firestoreService.getImageCustomerStream(docId);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 247, 222),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.only(top: 70, left: 70),
                child: Image.network(widget.image, height: 250, width: 250),
              ),
              Container(
                padding: EdgeInsets.only(top: 40, left: 8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.black, // สีของเส้น
            thickness: 1, // ความหนาของเส้น
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.type, style: TextStyle(fontSize: 20)),
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              SizedBox(width: 20),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: ClipOval(
                  child: Image.network(widget.image, fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: TextStyle(fontSize: 18)),
                  StreamBuilder(
                    stream: firestoreService.getRating(widget.documentId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text(
                          "ยังไม่มีรีวิว",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        );
                      }

                      final reviews =
                          snapshot.data!; // List<Map<String, dynamic>>

                      // คำนวณค่าเฉลี่ยของ rating ทั้งหมด
                      final totalRating = reviews
                          .map((review) => (review['rating'] as num?) ?? 0)
                          .reduce((a, b) => a + b);
                      final averageRating = totalRating / reviews.length;
                      return RatingBarIndicator(
                        rating: averageRating.toDouble(),
                        itemBuilder:
                            (context, index) =>
                                const Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 30.0,
                        direction: Axis.horizontal,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(width: 5),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  var customerProvider = Provider.of<employeeProvider>(
                    context,
                    listen: false,
                  );
                  customerProvider.setempolyeeName(widget.name);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MapPage(documentId: widget.documentId),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[300],
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(5),
                ),
                child: Image.asset('assets/icon/booking.png', width: 20),
              ),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 25),
          Stack(
            children: [
              StreamBuilder<String>(
                stream: imageStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    String imagePath = snapshot.data ?? 'ไม่พบข้อมูล';
                    return FutureBuilder<String>(
                      future: firestoreService.getImageEmpolyee(imagePath),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox.shrink();
                        }
                        String imageUrl = snapshot.data!;
                        return imageUrl == 'ไม่พบข้อมูล'
                            ? Text(imageUrl)
                            : Flexible(
                              child: Container(
                                width: 80,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                      },
                    );
                  } else {
                    return Text('ไม่พบข้อมูล');
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 5),
          Expanded(
            child: Stack(
              children: [
                _buildReviewSection(),

                Positioned(
                  bottom: 45,
                  right: 20,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 25, 98, 47),
                      minimumSize: Size(100, 50),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: Offset(0, -3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  'ให้คะแนน',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(height: 10),
                                RatingBar.builder(
                                  initialRating: 0,
                                  minRating: 1,
                                  itemSize: 40,
                                  direction: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Icon(
                                      Icons.star,
                                      color:
                                          index < 5
                                              ? Colors.amber
                                              : Colors.grey,
                                    );
                                  },
                                  onRatingUpdate: (newRating) {
                                    rating = newRating;
                                    print('คะแนนที่ได้: $rating');
                                  },
                                ),
                                SizedBox(height: 15),
                                SizedBox(
                                  width: 320,
                                  height: 100,
                                  child: TextFormField(
                                    controller: _commentController,
                                    maxLines: 7,
                                    decoration: InputDecoration(
                                      hintText: 'กรอกข้อความ...',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 15,
                                        horizontal: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(
                                      255,
                                      25,
                                      98,
                                      47,
                                    ),
                                    minimumSize: Size(100, 40),
                                  ),
                                  onPressed: () {
                                    final String comment =
                                        _commentController.text;
                                    firestoreService.addReview(
                                      widget.documentId,
                                      rating,
                                      comment,
                                      docId,
                                    );

                                    Navigator.pop(context);
                                    _commentController.clear();
                                  },
                                  child: Text(
                                    'ยืนยัน',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      'คอมเมนต์',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReviewTile(Map<String, dynamic> review) {
    final String customerId = review["customerId"] ?? "ผู้ใช้ไม่ระบุชื่อ";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StreamBuilder<String>(
                stream: firestoreService.getImageCustomerStream(customerId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    String imageUrl = snapshot.data ?? 'ไม่พบข้อมูล';
                    return imageUrl == 'ไม่พบข้อมูล'
                        ? Text(imageUrl)
                        : Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                  } else {
                    return Text('ไม่พบข้อมูล');
                  }
                },
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<String>(
                    stream: firestoreService.getUserNameStream(customerId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        return Text(
                          '${snapshot.data}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return Text(
                          'ไม่พบข้อมูล',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < (review["rating"] ?? 0)
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(review["comment"] ?? "", style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: firestoreService.getReviews(widget.documentId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),

            child: Center(
              child: Text(
                "ยังไม่มีรีวิว",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final reviews = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "รีวิวจากลูกค้า",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              //SizedBox(height: 15),
              Expanded(
                // height: 326,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    return buildReviewTile(reviews[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
