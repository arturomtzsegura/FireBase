import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'author.dart';

class AddAuthorDialog extends StatefulWidget {
  @override
  _AddAuthorDialogState createState() => _AddAuthorDialogState();
}

class _AddAuthorDialogState extends State<AddAuthorDialog> {
  final TextEditingController _authorNameController = TextEditingController();
  final TextEditingController _authorIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar Autor'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _authorIdController,
            decoration: InputDecoration(labelText: 'Identificador del Autor'),
          ),
          TextField(
            controller: _authorNameController,
            decoration: InputDecoration(labelText: 'Nombre del Autor'),
          ),
        ],
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
            // Obtén el nombre y el identificador del autor
            final String authorId = _authorIdController.text;
            final String authorName = _authorNameController.text;

            // Crea un objeto Author
            Author newAuthor = Author(authorName, authorId);

            try {
              // Accede a tu colección "Autores" en Firestore y agrega el nuevo autor.
              await FirebaseFirestore.instance.collection('Author').add({
                'key': newAuthor.key,
                'Name': newAuthor.name,
              });

              // Luego, cierra el diálogo.
              Navigator.of(context).pop();
            } catch (e) {
              // Maneja cualquier error que pueda ocurrir al guardar en Firestore.
              print("Error al guardar el autor en Firestore: $e");
              // Puedes mostrar un mensaje de error al usuario si lo deseas.
            }
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
