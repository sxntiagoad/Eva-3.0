import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:eva/models/week.dart';

class Limpieza {
  final String docId;
  final String carId;
  final String fecha;
  final Map<String, Week> inspecciones;

  Limpieza({
    this.docId = '',
    required this.carId,
    required this.fecha,
    required this.inspecciones,
  });

  Limpieza copyWith({
    String? carId,
    String? fecha,
    Map<String, Week>? inspecciones,
    String? docId,
  }) {
    return Limpieza(
      carId: carId ?? this.carId,
      fecha: fecha ?? this.fecha,
      inspecciones: inspecciones ?? this.inspecciones,
      docId: docId ?? this.docId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'carro': carId,
      'fecha': fecha,
      'inspecciones': inspecciones.map(
        (key, value) => MapEntry(key, value.toMap()),
      ),
    };
  }

  factory Limpieza.fromMap(Map<String, dynamic> map) {
    return Limpieza(
      carId: map['carro'] ?? '',
      fecha: map['fecha'] ?? '',
      inspecciones: (map['inspecciones'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, Week.fromMap(value)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Limpieza.fromJson(String source) =>
      Limpieza.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Limpieza(docId: $docId, carId: $carId, fecha: $fecha, inspecciones: $inspecciones)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Limpieza &&
        other.docId == docId &&
        other.carId == carId &&
        other.fecha == fecha &&
        mapEquals(other.inspecciones, inspecciones);
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        carId.hashCode ^
        fecha.hashCode ^
        inspecciones.hashCode;
  }
}
