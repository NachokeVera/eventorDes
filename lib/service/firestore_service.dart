import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/material.dart';

class FirestoreService {
  //obtener lista de estudiantes
  Stream<QuerySnapshot> eventos() {
    // return FirebaseFirestore.instance.collection('estudiantes').snapshots();
    return FirebaseFirestore.instance
        .collection('eventos')
        .orderBy('fecha')
        .snapshots();
    // return FirebaseFirestore.instance.collection('estudiantes').where('edad', isLessThanOrEqualTo: 25).snapshots();
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
}
