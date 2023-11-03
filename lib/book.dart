import 'package:cloud_firestore/cloud_firestore.dart';

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

Future<void> editBook(String id, String newTitle) async {
  try {
    // Access your "Book" collection in Firestore and update the book.
    await FirebaseFirestore.instance
        .collection('Book')
        .doc(id)
        .update({'title': newTitle});
  } catch (e) {
    // Handle any error that might occur when saving to Firestore.
    print("Error updating the book in Firestore: $e");
    // You can show an error message to the user if you want.
  }
}

Future<void> deleteBook(String id) async {
  try {
    // Access your "Book" collection in Firestore and delete the book.
    await FirebaseFirestore.instance
        .collection('Book')
        .doc(id) // Replace 'book.id' with the ID of the book you want to delete.
        .delete();
  } catch (e) {
    // Maneja cualquier error que pueda ocurrir al guardar en Firestore.
    print("Error al guardar el libro en Firestore: $e");
    // Puedes mostrar un mensaje de error al usuario si lo deseas.
  }
}