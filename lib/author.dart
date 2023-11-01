import 'package:cloud_firestore/cloud_firestore.dart';

class Author {
  String key;
  String? name;

  Author(this.name, this.key);

  Author.fromSnapshot(DocumentSnapshot snapshot)
      : key = snapshot['key'],
        name = snapshot['name'];

  toJson() {
    return {
      "key": key,
      "name": name,
    };
  }
}
