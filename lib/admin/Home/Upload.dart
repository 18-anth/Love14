import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String selectedCategory = 'Poemas';
  final categories = ['Poemas', 'Moments', 'Histories'];

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final authorController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  List<String> imageUrls = [];
  List<String> videoUrls = [];

  Future<void> pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) {
      for (var file in result.files) {
        final url = await uploadFile(
          File(file.path!),
          'uploads/images/${file.name}',
        );
        imageUrls.add(url);
      }
      setState(() {});
    }
  }

  Future<void> pickVideos() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.video,
    );
    if (result != null) {
      for (var file in result.files) {
        final url = await uploadFile(
          File(file.path!),
          'uploads/videos/${file.name}',
        );
        videoUrls.add(url);
      }
      setState(() {});
    }
  }

  Future<String> uploadFile(File file, String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> uploadPoem() async {
    await FirebaseFirestore.instance
        .collection('Uploads')
        .doc('Poemas')
        .collection('Items')
        .add({
          'title': titleController.text,
          'content': contentController.text,
          'author': authorController.text,
          'isFavorite': false,
          'date': Timestamp.now(),
        });
    _clearFields();
  }

  Future<void> uploadMoment() async {
    await FirebaseFirestore.instance
        .collection('Uploads')
        .doc('Moments')
        .collection('Items')
        .add({
          'title': titleController.text,
          'date': Timestamp.fromDate(selectedDate),
          'images': imageUrls,
          'videos': videoUrls,
        });
    _clearFields();
  }

  Future<void> uploadHistory() async {
    await FirebaseFirestore.instance
        .collection('Uploads')
        .doc('Histories')
        .collection('Items')
        .add({
          'title': titleController.text,
          'description': descriptionController.text,
          'date': Timestamp.fromDate(selectedDate),
          'images': imageUrls,
        });
    _clearFields();
  }

  void _clearFields() {
    titleController.clear();
    contentController.clear();
    authorController.clear();
    descriptionController.clear();
    imageUrls = [];
    videoUrls = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Content')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (value) => setState(() => selectedCategory = value!),
              items:
                  categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),

            // Shared field
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),

            if (selectedCategory == 'Poemas') ...[
              TextField(
                controller: contentController,
                maxLines: 6,
                decoration: InputDecoration(labelText: 'Contenido'),
              ),
              TextField(
                controller: authorController,
                decoration: InputDecoration(labelText: 'Autor'),
              ),
              ElevatedButton(onPressed: uploadPoem, child: Text('Subir Poema')),
            ] else if (selectedCategory == 'Moments') ...[
              ElevatedButton(
                onPressed: pickImages,
                child: Text('Seleccionar Imágenes'),
              ),
              ElevatedButton(
                onPressed: pickVideos,
                child: Text('Seleccionar Videos'),
              ),
              ElevatedButton(
                onPressed: uploadMoment,
                child: Text('Subir Moment'),
              ),
            ] else if (selectedCategory == 'Histories') ...[
              TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              ElevatedButton(
                onPressed: pickImages,
                child: Text('Seleccionar Imágenes'),
              ),
              ElevatedButton(
                onPressed: uploadHistory,
                child: Text('Subir History'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
