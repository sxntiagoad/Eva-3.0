import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:eva/models/car.dart';
import 'package:eva/models/firebase_file.dart';
import 'package:eva/providers/limpieza/limpieza_file_provider.dart';
import 'package:eva/providers/firebase_api.dart';
import 'package:intl/intl.dart';

class CarLimpieza extends ConsumerWidget {
  
  final Car car;

  const CarLimpieza({required this.car, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relevantExcelFiles = ref.watch(relevantExcelFilesProvider(car.carPlate));
    final selectedFiles = ref.watch(selectedFilesProvider);

    void refreshData() {
      ref.invalidate(excelFilesProvider);
      ref.invalidate(limpiezaByUidProvider);
      ref.invalidate(carByIdProvider);
      ref.invalidate(userByIdProvider);
      ref.read(refreshTriggerProvider.notifier).state++;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade50,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(car.carPlate,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900)),
            Text('Registro de Limpiezas',
                style: TextStyle(fontSize: 14, color: Colors.green.shade700)),
          ],
        ),
        actions: [
          if (selectedFiles.isNotEmpty)
            Chip(
              label: Text('${selectedFiles.length} seleccionados',
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.green.shade600,
            ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.green.shade700),
            onPressed: refreshData,
            tooltip: 'Actualizar datos',
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: selectedFiles.isNotEmpty ? Colors.green.shade700 : Colors.grey,
            ),
            onPressed: selectedFiles.isNotEmpty
                ? () async {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmar eliminación'),
                        content: Text(
                            '¿Estás seguro de eliminar ${selectedFiles.length} registros?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                              try {
                                await deleteSelectedFiles(ref);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Registros eliminados correctamente'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                                refreshData();
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error al eliminar registros: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ),
                    );
                  }
                : null,
            tooltip: 'Eliminar seleccionados',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => refreshData(),
        child: relevantExcelFiles.when(
          data: (relevantFiles) {
            if (relevantFiles.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cleaning_services_outlined,
                        size: 100, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No hay registros de limpieza',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: refreshData,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Actualizar'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade50, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total de registros',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${relevantFiles.length}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade900,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.check_circle,
                                      size: 16, color: Colors.green.shade700),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Completadas: ${relevantFiles.where((f) => f['isOpen']).length}',
                                    style: TextStyle(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.cancel,
                                      size: 16, color: Colors.red.shade700),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Pendientes: ${relevantFiles.where((f) => !f['isOpen']).length}',
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: relevantFiles.length,
                    itemBuilder: (context, index) {
                      final fileInfo = relevantFiles[index];
                      final isSelected = selectedFiles.contains(fileInfo['fileName']);
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        elevation: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: fileInfo['isOpen'] 
                                    ? Colors.green.shade600 
                                    : Colors.red.shade600,
                                width: 4,
                              ),
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              ref
                                  .read(selectedFilesProvider.notifier)
                                  .toggleSelection(fileInfo['fileName']);
                            },
                            leading: Checkbox(
                              value: isSelected,
                              activeColor: Colors.green,
                              onChanged: (bool? value) {
                                ref
                                    .read(selectedFilesProvider.notifier)
                                    .toggleSelection(fileInfo['fileName']);
                              },
                            ),
                            title: Row(
                              children: [
                                Text(
                                  fileInfo['userName'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: fileInfo['isOpen'] 
                                        ? Colors.green.shade50 
                                        : Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: fileInfo['isOpen'] 
                                          ? Colors.green.shade200 
                                          : Colors.red.shade200,
                                    ),
                                  ),
                                  child: Text(
                                    fileInfo['isOpen'] ? 'Completada' : 'Pendiente',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: fileInfo['isOpen'] 
                                          ? Colors.green.shade700 
                                          : Colors.red.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: 14, color: Colors.green.shade300),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateFormat('dd MMM yyyy HH:mm')
                                          .format(fileInfo['fecha']),
                                      style: TextStyle(
                                          color: Colors.green.shade700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                  icon: const Icon(Icons.file_download, size: 18),
                                  label: const Text('Descargar'),
                                  onPressed: () async {
                                    try {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => const Center(
                                          child: Card(
                                            child: Padding(
                                              padding: EdgeInsets.all(16),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<
                                                        Color>(Colors.green),
                                                  ),
                                                  SizedBox(height: 16),
                                                  Text('Descargando archivo...'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );

                                      final firebaseFile = await _getFirebaseFile(
                                          fileInfo['fileName']);
                                      if (firebaseFile != null) {
                                        Navigator.pop(context);
                                        await _downloadFile(firebaseFile, context);
                                      } else {
                                        throw Exception(
                                            'No se pudo obtener el archivo');
                                      }
                                    } catch (e) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Error: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando registros de limpieza...'),
              ],
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error'),
                ElevatedButton.icon(
                  onPressed: refreshData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          // Navegar a la pantalla de nuevo registro de limpieza
          Navigator.pushNamed(
            context,
            '/edit-limpieza',
            arguments: car,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<FirebaseFile?> _getFirebaseFile(String fileName) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('chequeos_limpieza/$fileName');
      final url = await ref.getDownloadURL();
      return FirebaseFile(ref: ref, name: fileName, url: url);
    } catch (e) {
      return null;
    }
  }

  Future _downloadFile(FirebaseFile file, BuildContext context) async {
    try {
      await FirebaseApi.downloadFile(file.ref);
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Archivo descargado: ${file.name}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al descargar archivo: $e')),
        );
      }
    }
  }
}
