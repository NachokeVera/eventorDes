import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/material.dart';

class FirestoreService {
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance
        .collection('eventos')
        .orderBy('fecha')
        .snapshots();
  }

  Future uploadFile(PlatformFile img) async {
    final path = 'imagenes/${img.name}';
    final file = File(img.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
  }

  Future<void> eventoAgregar(String nombre, String lugar, String descripcion,
      DateTime fecha, String tipo, String imgPath) async {
    return FirebaseFirestore.instance.collection('eventos').doc().set({
      'nombre': nombre,
      'lugar': lugar,
      'descripcion': descripcion,
      'fecha': fecha,
      'tipo': tipo,
      'imgPath': imgPath,
      'likes': 0,
    });
  }

  Future<String> getImageUrl(String imagePath) async {
    final ref = FirebaseStorage.instance.ref().child(imagePath);
    return ref.getDownloadURL();
  }

  Future<void> actualizarLikes(String eventId, int like) async {
    await FirebaseFirestore.instance
        .collection('eventos')
        .doc(eventId)
        .update({'likes': like});
  }

  Future<void> eliminarEvento(String eventId) async {
    await FirebaseFirestore.instance
        .collection('eventos')
        .doc(eventId)
        .delete();
  }

  Future<Map<String, dynamic>> getEvento(String eventId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('eventos')
        .doc(eventId)
        .get();

    return snapshot.data() as Map<String, dynamic>;
  }
}
