import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:eva/models/preoperacional.dart';
import 'package:eva/models/car.dart';
import 'package:firebase_auth/firebase_auth.dart';

final excelFilesProvider = FutureProvider.autoDispose((ref) async {
  ref.watch(refreshTriggerProvider);

  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("Usuario no autenticado");
    }
    final storageRef = FirebaseStorage.instance.ref().child('preoperacionales/');
    final ListResult result = await storageRef.listAll();
    final List fileNames = result.items.map((item) => item.name).toList();
    return fileNames;
  } catch (e) {
    throw Exception("Error al obtener archivos de Storage: $e");
  }
});

final preoperacionalByUidProvider = FutureProvider.autoDispose
    .family<Preoperacional?, String>((ref, uid) async {
  ref.watch(refreshTriggerProvider);
  uid = uid.split('.')[0];
  final doc = await FirebaseFirestore.instance
      .collection('preoperacionales')
      .doc(uid)
      .get();
  if (doc.exists) {
    return Preoperacional.fromMap(doc.data()!).copyWith(docId: doc.id);
  }
  return null;
});

final carByIdProvider =
    FutureProvider.autoDispose.family<Car?, String>((ref, carId) async {
  ref.watch(refreshTriggerProvider);
  final doc =
      await FirebaseFirestore.instance.collection('cars').doc(carId).get();
  if (doc.exists) {
    return Car.fromMap(doc.data()!);
  }
  return null;
});

final userByIdProvider =
    FutureProvider.autoDispose.family<String, String>((ref, userId) async {
  ref.watch(refreshTriggerProvider);
  final doc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (doc.exists && doc.data()!.containsKey('fullName')) {
    return doc.data()!['fullName'] as String;
  }
  return 'Usuario Desconocido';
});

final refreshTriggerProvider = StateProvider.autoDispose((ref) => 0);

final relevantExcelFilesProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, carPlate) async {
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

  // Sort the relevantFiles list by finalDate in descending order
  relevantFiles.sort((a, b) {
    final aDate = a['finalDate'].isNotEmpty ? a['finalDate'] : a['initDate'];
    final bDate = b['finalDate'].isNotEmpty ? b['finalDate'] : b['initDate'];
    return bDate.compareTo(aDate); // Descending order
  });

  return relevantFiles;
});

class SelectedFilesNotifier extends StateNotifier<Set> {
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
    StateNotifierProvider<SelectedFilesNotifier, Set>((ref) {
  return SelectedFilesNotifier();
});

final deleteFilesProvider = FutureProvider.autoDispose.family<void, List>((ref, fileNames) async {
  final storageRef = FirebaseStorage.instance.ref().child('preoperacionales/');
  final firestoreRef = FirebaseFirestore.instance.collection('preoperacionales');

  for (String fileName in fileNames) {
    try {
      await storageRef.child(fileName).delete();
      String docId = fileName.split('.')[0];
      await firestoreRef.doc(docId).delete();
    } catch (e) {
      rethrow;
    }
  }

  ref.invalidate(excelFilesProvider);
  ref.invalidate(relevantExcelFilesProvider);
  ref.read(refreshTriggerProvider.notifier).state++;
});

Future deleteSelectedFiles(WidgetRef ref) async {
  final selectedFiles = ref.read(selectedFilesProvider);
  if (selectedFiles.isNotEmpty) {
    try {
      await ref.read(deleteFilesProvider(selectedFiles.toList()).future);
      ref.read(selectedFilesProvider.notifier).clearSelection();
    } catch (e) {
      // Handle error
    }
  }
}

Future deleteFiles(List fileNames) async {
  final storageRef = FirebaseStorage.instance.ref().child('preoperacionales/');
  for (String fileName in fileNames) {
    try {
      await storageRef.child(fileName).delete();
    } catch (e) {
      // Handle error
    }
  }
}