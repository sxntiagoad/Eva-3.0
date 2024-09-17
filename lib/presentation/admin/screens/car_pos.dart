import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:eva/models/car.dart';
import 'package:eva/models/firebase_file.dart';
import 'package:eva/providers/excel_provider.dart';
import 'package:eva/providers/firebase_api.dart';
import 'package:intl/intl.dart';

class CarPos extends ConsumerWidget {
  final Car car;

  const CarPos({required this.car, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relevantExcelFiles = ref.watch(relevantExcelFilesProvider(car.carPlate));

    return Scaffold(
      appBar: AppBar(
        title: Text('Archivos de ${car.carPlate}'),
      ),
      body: relevantExcelFiles.when(
        data: (relevantFiles) {
          if (relevantFiles.isEmpty) {
            return const Center(child: Text('No hay archivos Excel para este carro'));
          }
          return ListView.builder(
            itemCount: relevantFiles.length,
            itemBuilder: (context, index) {
              final fileInfo = relevantFiles[index];
              return ListTile(
                leading: Icon(
                  Icons.table_chart,
                  color: fileInfo['isOpen'] ? Colors.green : Colors.red,
                ),
                title: Text(fileInfo['userName']),
                subtitle: Row(
                  children: [
                    Text(_formatDate(fileInfo['date'])),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: fileInfo['isOpen'] ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        fileInfo['isOpen'] ? 'Abierto' : 'Cerrado',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.file_download),
                  onPressed: () => _downloadFile(fileInfo['fileName'], context),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }


  String _formatDate(String dateString) {
    // Asumimos que dateString está en formato "yyyy-MM-dd"
    try {
      final date = DateTime.parse(dateString);
      final dateFormat = DateFormat('dd MMM yyyy');
      return dateFormat.format(date);
    } catch (e) {
      print('Error al formatear la fecha: $e');
      return dateString; // Devolvemos la fecha original si hay un error
    }
  }

  Future<FirebaseFile?> _getFirebaseFile(String fileName) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('preoperacionales/$fileName');
      final url = await ref.getDownloadURL();
      return FirebaseFile(ref: ref, name: fileName, url: url);
    } catch (e) {
      print('Error obteniendo archivo Firebase: $e');
      return null;
    }
  }

  Future<void> _downloadFile(FirebaseFile file, BuildContext context) async {
    try {
      await FirebaseApi.downloadFileWeb(file.ref);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Archivo descargado: ${file.name}')),
      );
    } catch (e) {
      print('Error al descargar archivo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al descargar archivo: $e')),
      );
    }
  }
}