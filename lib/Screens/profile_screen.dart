import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _dbRef = FirebaseDatabase.instance.ref();
  final _firestore = FirebaseFirestore.instance;

  String name = '';
  String email = '';
  Map<dynamic, dynamic>? favoritePoems;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userSnapshot = await _dbRef.child('Control/${user.uid}').get();

    if (userSnapshot.exists) {
      final data = userSnapshot.value as Map<dynamic, dynamic>;
      setState(() {
        name = data['name'] ?? '';
        email = data['email'] ?? '';
        favoritePoems = data['favorites'] as Map<dynamic, dynamic>?;
      });
    }
  }

  Future<Widget> _buildFavoritesList() async {
    if (favoritePoems == null || favoritePoems!.isEmpty) {
      return const Text("No tienes poemas favoritos.");
    }

    final List<Widget> poemWidgets = [];

    for (var poemId in favoritePoems!.keys) {
      // Buscar en Firestore por ID
      final docSnapshot =
          await _firestore
              .collection('Uploads')
              .doc('Poemas')
              .collection('Items')
              .doc(poemId)
              .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        poemWidgets.add(
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading:
                  data['imageUrl'] != null
                      ? Image.network(
                        data['imageUrl'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                      : const Icon(Icons.book),
              title: Text(data['title'] ?? 'Sin título'),
              subtitle: Text("Autor: ${data['author'] ?? 'Desconocido'}"),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        );
      }
    }

    return Column(children: poemWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xfff3ece7),
              radius: 80,
              backgroundImage: AssetImage('assets/image/naydelin.jpeg'),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Divider(height: 32),
            const Text(
              'Poemas Favoritos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FutureBuilder<Widget>(
              future: _buildFavoritesList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Text("Error al cargar favoritos.");
                }
                return snapshot.data!;
              },
            ),
          ],
        ),
      ),
    );
  }
}
