import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PreoperacionalesPage extends StatefulWidget {
  @override
  _PreoperacionalesPageState createState() => _PreoperacionalesPageState();
}

class _PreoperacionalesPageState extends State<PreoperacionalesPage> {
  List<String> _fileNames = [];

  @override
  void initState() {
    super.initState();
    _loadExcelFiles();
  }

  Future<void> _loadExcelFiles() async {
    try {
      // Referencia a la carpeta "preoperacionales"
      final ListResult result =
          await FirebaseStorage.instance.ref('preoperacionales/').listAll();

      print(
          'Archivos obtenidos: ${result.items.length}'); // Log: Número de archivos obtenidos

      // Lista para almacenar los nombres de archivos
      final List<String> fileNames = [];

      // Iterar sobre cada archivo y obtener sus metadatos
      for (var item in result.items) {
        print(
            'Obteniendo metadatos para: ${item.name}'); // Log: Nombre de cada archivo
        final metadata = await item.getMetadata();

        // Filtrar archivos por tipo de contenido o extensión (Excel)
        if (metadata.contentType ==
                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ||
            metadata.name.endsWith('.xlsx')) {
          print(
              'Archivo Excel detectado: ${metadata.name}'); // Log: Archivos Excel encontrados
          fileNames.add(
              metadata.name); // Acceder al nombre a través de los metadatos
        } else {
          print(
              'Archivo no es Excel: ${metadata.name}, tipo: ${metadata.contentType}'); // Log: Archivos no Excel
        }
      }

      print(
          'Nombres de archivos Excel encontrados: $fileNames'); // Log: Lista final de nombres de archivos

      setState(() {
        _fileNames = fileNames;
      });
    } catch (e) {
      print('Error al obtener los archivos: $e'); // Log: Imprimir errores
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archivos Preoperacionales'),
      ),
      body: _fileNames.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _fileNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_fileNames[index]),
                );
              },
            ),
    );
  }
}
