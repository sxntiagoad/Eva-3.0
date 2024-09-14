import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eva/models/car.dart';
import 'package:eva/providers/excel_provider.dart';

class CarPos extends ConsumerWidget {
  final Car car;

  const CarPos({required this.car, Key? key}) : super(key: key);

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
              final file = relevantFiles[index];
              return ListTile(
                title: Text(file),
                onTap: () {
                  // Aquí puedes añadir la funcionalidad para descargar o ver el archivo
                  print('Archivo seleccionado: $file');
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
