// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:universal_html/html.dart' as universal_html;
import 'dart:html' as html;
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
      // Convertir los datos de respuesta a Uint8List
      Uint8List bytes = Uint8List.fromList(response.data);

      // Verificar si es entorno web o móvil
      if (universal_html.window.navigator.userAgent.contains('Chrome')) {
        // Código para navegadores web
        uploadToFirebaseWeb(bytes, archiveName);
      } else {
        // Código para aplicaciones móviles
        await uploadToFirebaseMobile(bytes, archiveName);
      }
    } else {
      print('Error: ${response.statusCode} - ${response.statusMessage}');
    }
  } catch (e) {
    print('Ocurrió un error: $e');
  }
}

Future<void> uploadToFirebaseWeb(Uint8List bytes, String archiveName) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = storage.ref().child('preoperacionales/$archiveName.xlsx');

  UploadTask uploadTask = ref.putData(bytes);
  try {
    await uploadTask;
  } catch (e) {
    print('Error al subir archivo: $e');
  }
}

Future<void> uploadToFirebaseMobile(Uint8List bytes, String archiveName) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = storage.ref().child('preoperacionales/$archiveName.xlsx');

  UploadTask uploadTask = ref.putData(bytes);

  await uploadTask.whenComplete(() {
    print('Subida completada');
  });

}
