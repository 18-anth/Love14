import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:love14/layout/poem.dart';

class PoemController with ChangeNotifier {
  List<Poem> _poems = [];

  List<Poem> get poems => _poems;

  List<Poem> get favoritePoems =>
      _poems.where((poem) => poem.isFavorite).toList();

  PoemController() {
    fetchPoems();
  }

  Future<void> fetchPoems() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('Uploads')
            .doc('Poemas')
            .collection('Items')
            .orderBy('date', descending: true)
            .get();

    _poems =
        snapshot.docs.map((doc) => Poem.fromMap(doc.data(), doc.id)).toList();
    notifyListeners();
  }

  void toggleFavorite(String poemId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userId = user.uid;
    final index = _poems.indexWhere((poem) => poem.id == poemId);
    if (index == -1) return;

    final poem = _poems[index];
    final isNowFavorite = !poem.isFavorite;

    // Actualizar el modelo local
    _poems[index] = Poem(
      id: poem.id,
      title: poem.title,
      content: poem.content,
      author: poem.author,
      isFavorite: isNowFavorite,
      date: poem.date,
    );
    notifyListeners();

    // Firestore: sigue siendo útil si tienes lógica de visualización o backup
    await FirebaseFirestore.instance
        .collection('Uploads')
        .doc('Poemas')
        .collection('Items')
        .doc(poemId)
        .update({'isFavorite': isNowFavorite});

    // RealTime Database
    final db = FirebaseDatabase.instance.ref();

    if (isNowFavorite) {
      // Agregar usuario al poema
      await db.child('PoemFavorites/$poemId/$userId').set(true);
      // Agregar poema al usuario
      await db.child('Control/$userId/favorites/$poemId').set(true);
    } else {
      // Quitar usuario del poema
      await db.child('PoemFavorites/$poemId/$userId').remove();
      // Quitar poema del usuario
      await db.child('Control/$userId/favorites/$poemId').remove();
    }
  }
}
