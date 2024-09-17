import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:eva/models/preoperacional.dart';
import 'package:eva/models/car.dart';
import 'package:firebase_auth/firebase_auth.dart';

final excelFilesProvider = FutureProvider<List<String>>((ref) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("Usuario no autenticado");
    }
    final storageRef =
        FirebaseStorage.instance.ref().child('preoperacionales/');
    final ListResult result = await storageRef.listAll();
    final List<String> fileNames =
        result.items.map((item) => item.name).toList();
    print('Archivos obtenidos: $fileNames');
    return fileNames;
  } catch (e) {
    print('Error en excelFilesProvider: $e');
    throw Exception("Error al obtener archivos de Storage: $e");
  }
});

// Provider para obtener un Preoperacional por su UID
final preoperacionalByUidProvider =
    FutureProvider.family<Preoperacional?, String>((ref, uid) async {
  uid = uid.split('.')[0];
  final doc = await FirebaseFirestore.instance
      .collection('preoperacionales')
      .doc(uid)
      .get();
  if (doc.exists) {
    print('Preoperacional encontrado para UID: $uid');
    return Preoperacional.fromMap(doc.data()!).copyWith(docId: doc.id);
  }
  print('No se encontró Preoperacional para UID: $uid');
  return null;
});

// Provider para obtener un Car por su ID
final carByIdProvider = FutureProvider.family<Car?, String>((ref, carId) async {
  final doc =
      await FirebaseFirestore.instance.collection('cars').doc(carId).get();
  if (doc.exists) {
    print('Carro encontrado para ID: $carId');
    return Car.fromMap(doc.data()!);
  }
  print('No se encontró Carro para ID: $carId');
  return null;
});

final userByIdProvider = FutureProvider.family<String, String>((ref, userId) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (doc.exists && doc.data()!.containsKey('fullName')) {
    return doc.data()!['fullName'] as String;
  }
  return 'Usuario Desconocido';
});

final relevantExcelFilesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, carPlate) async {
  final excelFiles = await ref.watch(excelFilesProvider.future);
  List<Map<String, dynamic>> relevantFiles = [];

  for (String file in excelFiles) {
    final preoperacionalUid = file.split('.')[0];
    final preoperacional = await ref.read(preoperacionalByUidProvider(preoperacionalUid).future);
    if (preoperacional != null) {
      final car = await ref.read(carByIdProvider(preoperacional.carId).future);
      if (car != null && car.carPlate == carPlate) {
        final userName = await ref.read(userByIdProvider(preoperacional.userId).future);
        relevantFiles.add({
          'fileName': file,
          'userName': userName,
          'date': preoperacional.fecha,
          'isOpen' : preoperacional.isOpen,
          'preoperacionalUid': preoperacionalUid,
        });
      }
    }
  }
  return relevantFiles;
});