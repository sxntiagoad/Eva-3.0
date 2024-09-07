import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Provider para obtener los archivos de Excel
final excelFilesProvider = FutureProvider<List<Reference>>((ref) async {
  final storage = FirebaseStorage.instance;
  final ListResult result = await storage.ref('preoperacionales').listAll();

  // Filtra solo los archivos con extensión .xlsx o .xls
  final excelFiles = result.items.where((item) =>
      item.name.endsWith('.xlsx') || item.name.endsWith('.xls')).toList();

  return excelFiles;
});