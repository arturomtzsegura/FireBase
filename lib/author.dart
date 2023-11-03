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

Future<void> editAuthor(String id, String newName) async {
  try {
    // Access your "Book" collection in Firestore and update the book.
    await FirebaseFirestore.instance
        .collection('Author')
        .doc(id)
        .update({'Name': newName});
  } catch (e) {
    // Handle any error that might occur when saving to Firestore.
    print("Error al actualizar el libro en Firestore: $e");
    // You can show an error message to the user if you want.
  }
}

Future<void> deleteAuthor(String id) async {
  try {
    // Access your "Book" collection in Firestore and delete the book.
    await FirebaseFirestore.instance
        .collection('Author')
        .doc(id) // Replace 'book.id' with the ID of the book you want to delete.
        .delete();
  } catch (e) {
    // Maneja cualquier error que pueda ocurrir al guardar en Firestore.
    print("Error al eliminar el libro en Firestore: $e");
    // Puedes mostrar un mensaje de error al usuario si lo deseas.
  }
}
