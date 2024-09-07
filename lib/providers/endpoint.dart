// ignore_for_file: avoid_print

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> enviarJsonYSubirArchivoAFirebase({
  required Map<String, Map<String, Object>> jsonData,
  required String archiveName,
}) async {
  try {
    Dio dio = Dio();

    String url = 'https://web-production-1db54.up.railway.app/rellenar_excel';

    Response response = await dio.post(
      url,
      data: jsonData,
      options: Options(
        responseType: ResponseType.bytes,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      Directory tempDir = await getTemporaryDirectory();
      String filePath = "${tempDir.path}/$archiveName.xlsx";

      // Guardar el archivo temporalmente
      File file = File(filePath);
      await file.writeAsBytes(response.data);

      print('Archivo guardado temporalmente en: $filePath');

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('preoperacionales/$archiveName.xlsx');
      UploadTask uploadTask = ref.putFile(file);

      await uploadTask.whenComplete(() {
        print('Subida completada');
      });

      String downloadUrl = await ref.getDownloadURL();
      print('Archivo disponible en: $downloadUrl');
    } else {
      print('Error: ${response.statusCode} - ${response.statusMessage}');
    }
  } catch (e) {
    print('Ocurrió un error: $e');
  }
}
