import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/models/limpieza.dart';

class LimpiezaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> saveLimpieza(Limpieza limpieza) async {
    try {
      // Crear nuevo documento con ID automático
      final docRef = await _firestore.collection('limpieza').add(limpieza.toMap());
      
      // Actualizar el documento con su ID
      await docRef.update({'docId': docRef.id});
      
      return docRef.id;
    } catch (e) {
      throw Exception('Error al guardar limpieza: $e');
    }
  }
}