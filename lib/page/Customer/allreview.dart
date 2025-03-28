import 'package:flutter/material.dart';

class AllReviewsPage extends StatelessWidget {
  final List<Map<String, dynamic>> reviews; // ✅ เพิ่มพารามิเตอร์ reviews

  const AllReviewsPage({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("รีวิวทั้งหมด")),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return _buildReviewTile(review);
        },
      ),
    );
  }

  Widget _buildReviewTile(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_circle , size: 40, color: Colors.blueGrey),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review["reviewer"] ?? "ผู้ใช้ไม่ระบุชื่อ",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < (review["rating"] ?? 0) ? Icons.star : Icons.star_border,
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
}