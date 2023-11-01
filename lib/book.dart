import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Book {
  String? key;
  String? title;
  String? authorId;

  Book({this.key, this.title, this.authorId});

  Book.fromSnapshot(DocumentSnapshot snapshot)
      : key = snapshot['key'],
        title = snapshot['title'],
        authorId = snapshot['authorId'];

  toJson() {
    return {
      "key": key,
      "title": title,
      "authorId": authorId,
    };
  }
}
