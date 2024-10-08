import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/models/car.dart';
import 'package:eva/providers/current_user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/preoperacional.dart';
import '../../providers/car_provider.dart';
import '../../providers/endpoint.dart';

Future<void> dataJson(
    {required WidgetRef ref,
    required Preoperacional preoperacional,
    String idDoc = ''}) async {
  Map<String, Map<String, Object>> data = {};

  preoperacional.inspecciones.forEach((key, value) {
    data[key] = value.map((innerKey, week) => MapEntry(innerKey, week.toMap()));
  });
  
  final cars = await getAllCars();
  final currentCar = cars[preoperacional.carId];

  data["FORMULARIO"] = {
    "Codigo": "SESdd-SGIsds-F00323423",
    "Fecha de Emision": DateTime.now().toString(),
    "PLACAS No": currentCar?.carPlate ?? '',
    "MODELO": currentCar?.model ?? '',
    "MARCA": currentCar?.brand ?? '',
    "LUGAR": "Bogotá",
    "TIPO DE VEHICULO": currentCar?.carType ?? '',
    "F.V . TARJETA OPERACIÓN": obtenerFecha(currentCar, 'F.V_tarjetaOp', 'V_tarjetaOp'),
    "F.V . SOAT": obtenerFecha(currentCar, 'F.V_soat', 'V_soat'),
    "F.V . TECNICOMECANICA": obtenerFecha(currentCar, 'F.V_tecnicomec', 'V_tecnicomec'),
    "F.V . EXTRACTO": obtenerFecha(currentCar, 'F.V_extracto', 'V_extracto'),
    "BOTIQUÍN TIPO": preoperacional.typeKit,
    "SEMANA DEL": formatDate(preoperacional.fechaInit),
    "AL": formatDate(preoperacional.fechaFinal),
    "DEL 20": "24",
    "KMTS INICIAL": preoperacional.kilometrajeInit.toString(),
    "KMTS FINAL": preoperacional.kilometrajeFinal.toString(),
    "KMTS ÚLTIMO CAMBIO DE ACEITE": fecha(currentCar?.ultCambioAceite),
    "KMTS PROXIMO CAMBIO DE ACEITE": fecha(currentCar?.proxCambioAceite),
  };
  final user = ref.read(currentUserProvider);
  final userValue = user.value;

  final logoUrl = await getSESCOTURImageUrl();
  final firmaEncargadoUrl = await getManagerSignatureUrl();
  String firmaUrl = '';
  if (userValue != null) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      firmaUrl = await getUserSignatureUrl(uid);
    }
  }
  data['IMAGENES'] = {
    'FIRMA_USER': firmaUrl,
    'FIRMA_ENCARGADO': firmaEncargadoUrl,
    'LOGO': logoUrl,
  };

  data["PIE_TABLA"] = {
    "Nombre del Conductor": user.value?.fullName ?? '',
    "OBSERVACIONES": preoperacional.observaciones.isNotEmpty
        ? preoperacional.observaciones
        : 'Sin observaciones',
  };

  await enviarJsonYSubirArchivoAFirebase(
    jsonData: data,
    archiveName: preoperacional.docId.isEmpty ? idDoc : preoperacional.docId,
  );
}

String fecha(Timestamp? fecha) {
  if (fecha != null) {
    print("bien");
    DateTime dateTime = fecha.toDate();
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');

    String formattedDate = '$year-$month-$day $hour:$minute';
    return formattedDate;
  }
  return 'Sin fechaAA';
}

String obtenerFecha(Car? car, String campoOriginal, String campoF) {
  if (car == null) return 'Sin fecha';
  final carMap = car.toMap();
  print('Car Map: $carMap');
  print('Is First Time: ${car.isFirstTime}');
  
  if (car.isFirstTime == true) {
    print('Es primera vez');
    return fecha(carMap[campoOriginal] as Timestamp?);
  } else {
    print('No es primera vez');
    final fMap = carMap['F'] as Map<String, dynamic>?;
    print('F Map: $fMap');
    if (fMap != null && fMap.containsKey(campoF)) {
      final fechaStr = fMap[campoF] as String?;
      if (fechaStr != null && fechaStr.isNotEmpty) {
        print('Fecha de F: $fechaStr');
        return fechaStr;
      }
    }
  }
  return 'Sin fecha';
}

String formatDate(String? fecha) {
  if (fecha == null || fecha.isEmpty) return 'Sin fecha';
  try {
    DateTime dateTime = DateTime.parse(fecha);
    String dia = dateTime.day.toString().padLeft(2, '0');
    String mes = dateTime.month.toString().padLeft(2, '0');
    String hora = dateTime.hour.toString().padLeft(2, '0');
    String minutos = dateTime.minute.toString().padLeft(2, '0');

    return '$dia/$mes $hora:$minutos';
  } catch (e) {
    return 'Fecha inválida';
  }
}

Future<String> getSESCOTURImageUrl() async {
  try {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('SESCOTUR.png');
    final url = await ref.getDownloadURL();
    return url;
  } catch (e) {
    // ignore: avoid_print
    print('Error al obtener la URL de SESCOTUR.png: $e');
    return ''; // Retorna una cadena vacía en caso de error
  }
}

Future<String> getManagerSignatureUrl() async {
  try {
    return await FirebaseStorage.instance.ref('FIRMA_ROGER.png').getDownloadURL();
  } catch (e) {
    // ignore: avoid_print
    print('Error al obtener la firma del encargado: $e');
    return '';
  }
}

Future<String> getUserSignatureUrl(String uid) async {
  try {
    return await FirebaseStorage.instance.ref('firmas/$uid.png').getDownloadURL();
  } catch (e) {
    // ignore: avoid_print
    print('Error al obtener la firma del usuario: $e');
    return '';
  }
}
