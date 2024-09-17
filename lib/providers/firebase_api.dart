import 'dart:html' as html;
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static Future<void> downloadFileWeb(Reference ref) async {
    try {
      // Obtiene la URL de descarga del archivo en Firebase Storage
      final downloadUrl = await ref.getDownloadURL();
      
      // Crea un elemento <a> invisible que se usará para iniciar la descarga
      final anchor = html.AnchorElement(href: downloadUrl)
        ..setAttribute("download", ref.name) // Configura el nombre del archivo
        ..click(); // Inicia la descarga simulando un clic en el <a>
      
      print('Archivo descargado: ${ref.name}');
    } catch (e) {
      print('Error al descargar archivo: $e');
    }
  }
}
