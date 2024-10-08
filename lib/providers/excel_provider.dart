import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:eva/models/preoperacional.dart';
import 'package:eva/models/car.dart';
import 'package:firebase_auth/firebase_auth.dart';

final excelFilesProvider = FutureProvider.autoDispose((ref) async {
  // Observa el refreshTriggerProvider para que se actualice cuando cambie
  ref.watch(refreshTriggerProvider);

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
final preoperacionalByUidProvider = FutureProvider.autoDispose
    .family<Preoperacional?, String>((ref, uid) async {
  ref.watch(refreshTriggerProvider); // Observa el refreshTriggerProvider
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
final carByIdProvider =
    FutureProvider.autoDispose.family<Car?, String>((ref, carId) async {
  ref.watch(refreshTriggerProvider); // Observa el refreshTriggerProvider
  final doc =
      await FirebaseFirestore.instance.collection('cars').doc(carId).get();
  if (doc.exists) {
    print('Carro encontrado para ID: $carId');
    return Car.fromMap(doc.data()!);
  }
  print('No se encontró Carro para ID: $carId');
  return null;
});

final userByIdProvider =
    FutureProvider.autoDispose.family<String, String>((ref, userId) async {
  ref.watch(refreshTriggerProvider); // Observa el refreshTriggerProvider
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (doc.exists && doc.data()!.containsKey('fullName')) {
    return doc.data()!['fullName'] as String;
  }
  return 'Usuario Desconocido';
});

// Añade este nuevo provider
final refreshTriggerProvider = StateProvider.autoDispose((ref) => 0);

// Modifica el relevantExcelFilesProvider para que sea autoDispose y use el refreshTriggerProvider
final relevantExcelFilesProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, carPlate) async {
  // Observa el refreshTriggerProvider para que se actualice cuando cambie
  ref.watch(refreshTriggerProvider);

  final excelFiles = await ref.watch(excelFilesProvider.future);
  List<Map<String, dynamic>> relevantFiles = [];

  for (String file in excelFiles) {
    final preoperacionalUid = file.split('.')[0];
    final preoperacional =
        await ref.read(preoperacionalByUidProvider(preoperacionalUid).future);
    if (preoperacional != null) {
      final car = await ref.read(carByIdProvider(preoperacional.carId).future);
      if (car != null && car.carPlate == carPlate) {
        final userName =
            await ref.read(userByIdProvider(preoperacional.userId).future);
        relevantFiles.add({
          'fileName': file,
          'userName': userName,
          'finalDate': preoperacional.fechaFinal,
          'initDate': preoperacional.fechaInit,
          'isOpen': preoperacional.isOpen,
          'preoperacionalUid': preoperacionalUid,
        });
      }
    }
  }
  return relevantFiles;
});



// Añade este nuevo provider
class SelectedFilesNotifier extends StateNotifier<Set<String>> {
  SelectedFilesNotifier() : super({});

  void toggleSelection(String fileName) {
    if (state.contains(fileName)) {
      state = Set.from(state)..remove(fileName);
    } else {
      state = Set.from(state)..add(fileName);
    }
  }

  void clearSelection() {
    state = {};
  }
}

final selectedFilesProvider =
    StateNotifierProvider<SelectedFilesNotifier, Set<String>>((ref) {
  return SelectedFilesNotifier();
});

// Nuevo provider para manejar la eliminación de archivos
final deleteFilesProvider = FutureProvider.autoDispose.family<void, List<String>>((ref, fileNames) async {
  final storageRef = FirebaseStorage.instance.ref().child('preoperacionales/');
  final firestoreRef = FirebaseFirestore.instance.collection('preoperacionales');

  for (String fileName in fileNames) {
    try {
      // Eliminar archivo de Firebase Storage
      await storageRef.child(fileName).delete();

      // Eliminar documento correspondiente de Firestore
      String docId = fileName.split('.')[0]; // Asumiendo que el nombre del archivo es el ID del documento
      await firestoreRef.doc(docId).delete();

      print('Archivo y documento eliminados: $fileName');
    } catch (e) {
      print('Error al eliminar archivo y documento $fileName: $e');
      throw e; // Propaga el error para manejarlo en la UI
    }
  }

  // Actualizar los providers relevantes
  ref.invalidate(excelFilesProvider);
  ref.invalidate(relevantExcelFilesProvider);
  ref.read(refreshTriggerProvider.notifier).state++;
});

// Función auxiliar para invocar la eliminación de archivos
Future<void> deleteSelectedFiles(WidgetRef ref) async {
  final selectedFiles = ref.read(selectedFilesProvider);
  if (selectedFiles.isNotEmpty) {
    try {
      await ref.read(deleteFilesProvider(selectedFiles.toList()).future);
      ref.read(selectedFilesProvider.notifier).clearSelection();
    } catch (e) {
      print('Error al eliminar archivos: $e');
      // Aquí puedes manejar el error, por ejemplo, mostrando un mensaje al usuario
    }
  }
}

Future<void> deleteFiles(List<String> fileNames) async {
  final storageRef = FirebaseStorage.instance.ref().child('preoperacionales/');
  for (String fileName in fileNames) {
    try {
      await storageRef.child(fileName).delete();
      print('Archivo eliminado: $fileName');
    } catch (e) {
      print('Error al eliminar archivo $fileName: $e');
    }
  }
}
