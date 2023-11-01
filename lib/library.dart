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
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'delete',
                                onPressed: () {
                                  // Llama a la función deleteBook para eliminar el libro

                                  // Recarga la lista de libros
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
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'delete',
                                onPressed: () {},
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
