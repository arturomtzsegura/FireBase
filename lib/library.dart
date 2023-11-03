import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_xdxd/author.dart';
import 'package:fire_xdxd/book.dart';
import 'package:flutter/material.dart';
import 'AddAuthorDialog.dart';
import 'addBookDialog.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final docClient = FirebaseFirestore.instance.collection("book").doc();
  final TextEditingController newTitle = TextEditingController();
  final TextEditingController newName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Libros y Autores'),
      ),
      body: _buildBody(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AddBookDialog();
                },
              );
            },
            child: const Icon(Icons.book),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AddAuthorDialog();
                },
              );
            },
            child: const Icon(Icons.person),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('Book').snapshots(),
      builder: (context, booksSnapshot) {
        if (!booksSnapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final books = booksSnapshot.data!.docs;
        return StreamBuilder<QuerySnapshot>(
          stream: _db.collection('Author').snapshots(),
          builder: (context, authorsSnapshot) {
            if (!authorsSnapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final authors = authorsSnapshot.data!.docs;

            return Column(
              children: [
                const Text(
                  'Libros:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return Card(
                        child: ListTile(
                          title: Text(book['title'] ?? 'Sin título'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.ads_click),
                                tooltip: 'Select',
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Edit Book Title'),
                                        content: TextField(
                                          controller: newTitle,
                                          decoration: InputDecoration(hintText: "Enter new title"),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Ok'),
                                            onPressed: () async {
                                              if(newTitle.text.isNotEmpty){
                                              editBook(book.id, newTitle.text);
                                              Navigator.of(context).pop();
                                              newTitle.clear();
                                              }else {
                                                Navigator.of(context).pop();
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return alerta(context, 'Para editar el titulo ingresa al menos un caracter');
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'delete',
                                onPressed: () async {
                                  // Llama a la función deleteBook para eliminar el libro
                                  deleteBook(book.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Text(
                  'Autores:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: authors.length,
                    itemBuilder: (context, index) {
                      final author = authors[index];
                      return Card(
                        child: ListTile(
                          title: Text(author['Name'] ?? 'Sin nombre'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.ads_click),
                                tooltip: 'Select',
                                onPressed: () async {showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Edita el autor'),
                                      content: TextField(
                                        controller: newName,
                                        decoration: InputDecoration(hintText: "Ingresa nuevo nombre"),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Ok'),
                                          onPressed: () async {
                                            if(newName.text.isNotEmpty){
                                              editAuthor(author.id, newName.text);
                                              Navigator.of(context).pop();
                                              newName.clear();
                                            }else {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return alerta(context, 'Para editar el nombre del autor ingresa al menos un caracter');
                                                },
                                              );
                                            }
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Cancelar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'delete',
                                onPressed:  () async {
                                  deleteAuthor(author.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

AlertDialog alerta(BuildContext context, String info){
  return AlertDialog(
    title: Text('¡Alerta!'),
    content: SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Text(info),
        ],
      ),
    ),
    actions: <Widget>[
      TextButton(
        child: Text('Ok'),
        onPressed: ()  {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}