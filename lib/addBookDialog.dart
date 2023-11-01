import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'book.dart';

class AddBookDialog extends StatefulWidget {
  @override
  _AddBookDialogState createState() => _AddBookDialogState();
}

class _AddBookDialogState extends State<AddBookDialog> {
  final TextEditingController _bookTitleController = TextEditingController();
  final TextEditingController _bookAuthorIdController = TextEditingController();
  final TextEditingController _bookIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar Libro'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _bookIdController,
              decoration: InputDecoration(labelText: 'ID Libro'),
            ),
            TextField(
              controller: _bookTitleController,
              decoration: InputDecoration(labelText: 'Título del Libro'),
            ),
            TextField(
              controller: _bookAuthorIdController,
              decoration: InputDecoration(labelText: 'ID del Autor'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el diálogo sin hacer nada.
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            // Obtén el título del libro y el ID del autor
            final String bookTitle = _bookTitleController.text;
            final String authorId = _bookAuthorIdController.text;
            final String id = _bookIdController.text;
            // Crea un objeto Book
            Book newBook = Book(key: id, title: bookTitle, authorId: authorId);

            try {
              // Accede a tu colección "Book" en Firestore y agrega el nuevo libro.
              await FirebaseFirestore.instance
                  .collection('Book')
                  .add(newBook.toJson());

              // Luego, cierra el diálogo.
              Navigator.of(context).pop();
            } catch (e) {
              // Maneja cualquier error que pueda ocurrir al guardar en Firestore.
              print("Error al guardar el libro en Firestore: $e");
              // Puedes mostrar un mensaje de error al usuario si lo deseas.
            }
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
