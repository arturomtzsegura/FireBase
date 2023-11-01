import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final TextEditingController _textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance; //Instancia de la base de datos
    final doc =
        db.doc('/Prueba/kUOld6lT41uHUtkOjFAZ'); //Intancia de la colecion
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase"),
      ),
      body: Center(
          child: Column(
        children: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: doc.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              final docsnap = snapshot.data!; //Instancia del documento
              return Text(docsnap['mensaje'] ?? "<campo no encontrado>");
            },
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(labelText: 'Nuevo mensaje'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _addToDatabase(_textFieldController.text);
            },
            child: const Text('add to database'),
          )
        ],
      )),
    );
  }

  void _addToDatabase(String nuevoMensaje) async {
    final db = FirebaseFirestore.instance;

    // Crea un nuevo documento con un ID automático en la colección 'Prueba'
    await db.collection('Prueba').add({
      'mensaje': nuevoMensaje,
      // Puedes agregar otros campos si es necesario
    });

    // Limpia el campo de entrada de texto después de agregar el documento
    _textFieldController.clear();
  }
}
