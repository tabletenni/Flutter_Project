// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Review {
  final String id;
  final String customerId; // ✅ เพิ่มฟิลด์ customerId
  final String reviewerName;
  final int rating;
  final String comment;
  final DateTime timestamp;

  Review({
    required this.id,
    required this.customerId,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  factory Review.fromJson(Map<String, dynamic> json, String id) {
    return Review(
      id: id,
      customerId: json['customerId'] ?? "", // ✅ ดึง customerId จาก Firestore
      reviewerName: json['reviewerName'] ?? 'ไม่ระบุชื่อ',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment'] ?? '',
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
