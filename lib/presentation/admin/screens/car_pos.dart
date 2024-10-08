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
    final selectedFiles = ref.watch(selectedFilesProvider);

    void refreshData() {
      ref.invalidate(excelFilesProvider);
      ref.invalidate(preoperacionalByUidProvider);
      ref.invalidate(carByIdProvider);
      ref.invalidate(userByIdProvider);
      ref.read(refreshTriggerProvider.notifier).state++;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Archivos de ${car.carPlate}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshData,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: selectedFiles.isNotEmpty
                ? () async {
                    await deleteSelectedFiles(ref);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Archivos eliminados')),
                    );
                    refreshData();
                  }
                : null,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          refreshData();
        },
        child: relevantExcelFiles.when(
          data: (relevantFiles) {
            if (relevantFiles.isEmpty) {
              return const Center(child: Text('No hay archivos Excel para este carro'));
            }
            return ListView.builder(
              itemCount: relevantFiles.length,
              itemBuilder: (context, index) {
                final fileInfo = relevantFiles[index];
                final isSelected = selectedFiles.contains(fileInfo['fileName']);
                return ListTile(
                  leading: Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      ref.read(selectedFilesProvider.notifier).toggleSelection(fileInfo['fileName']);
                    },
                  ),
                  title: Text(fileInfo['userName']),
                  subtitle: Row(
                    children: [
                      Text(_formatDate(fileInfo['finalDate'], fileInfo['initDate'])),
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
                    onPressed: () async {
                      final firebaseFile = await _getFirebaseFile(fileInfo['fileName']);
                      if (firebaseFile != null) {
                        await _downloadFile(firebaseFile, context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error al obtener el archivo')),
                        );
                      }
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  String _formatDate(String finalDate, String initDate) {
    try {
      final dateToUse = finalDate.isNotEmpty ? finalDate : initDate;
      final date = DateTime.parse(dateToUse);
      final dateFormat = DateFormat('dd MMM yyyy HH:mm:ss');
      return dateFormat.format(date);
    } catch (e) {
      print('Error al formatear la fecha: $e');
      return finalDate.isNotEmpty ? finalDate : initDate;
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
      await FirebaseApi.downloadFile(file.ref);
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