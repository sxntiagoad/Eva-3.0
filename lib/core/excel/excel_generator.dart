import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/preoperacional.dart';
import '../../providers/car_provider.dart';
import '../../providers/endpoint.dart';

Future<void> dataJson({
  required WidgetRef ref,
  required Preoperacional preoperacional,
  String idDoc=''
}) async {
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
    "F.V . TARJETA OPERACIÓN": fecha(currentCar?.tarjetaOp),
    "F.V . SOAT": fecha(currentCar?.soat),
    "F.V . TECNICOMECANICA": fecha(currentCar?.tecnicoMec),
    "F.V . EXTRACTO": fecha(currentCar?.extracto),
    "BOTIQUÍN TIPO": preoperacional.typeKit,
    "SEMANA DEL": "",
    "AL": "",
    "DEL 20": "",
    "KMTS INICIAL": "",
    "KMTS FINAL": "",
    "KMTS ÚLTIMO CAMBIO DE ACEITE": "",
    "KMTS PROXIMO CAMBIO DE ACEITE": ""
  };
  final user = ref.read(currentUserProvider);

  data["PIE_TABLA"] = {
    "Nombre del Conductor": user.value?.fullName ?? '',
    "OBSERVACIONES": preoperacional.observaciones.isNotEmpty
        ? preoperacional.observaciones
        : 'Sin observaciones',
  };

  await enviarJsonYSubirArchivoAFirebase(
    jsonData: data,
    archiveName: preoperacional.docId.isEmpty?idDoc:preoperacional.docId,
  );
}

String fecha(Timestamp? fecha) {
  if (fecha != null) {
    DateTime dateTime = fecha.toDate();

    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');

    String formattedDate = '$year-$month-$day $hour:$minute';
    return formattedDate;
  }
  return 'no hay fecha';
}
