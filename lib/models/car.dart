import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  final Timestamp? extracto;
  final Timestamp? soat;
  final Timestamp? tarjetaOp;
  final Timestamp? tecnicoMec;
  final String brand;
  final String carPlate;
  final String carType;
  final String model;
  final Timestamp? ultCambioAceite;
  final Timestamp? proxCambioAceite;
  final bool? isFirstTime;
  final Map<String, dynamic>? F;

  Car({
    required this.extracto,
    required this.soat,
    required this.tarjetaOp,
    required this.tecnicoMec,
    required this.brand,
    required this.carPlate,
    required this.carType,
    required this.model,
    this.isFirstTime = true,
    this.ultCambioAceite,
    this.proxCambioAceite,
    this.F,
  });

  Car copyWith({
    Timestamp? extracto,
    Timestamp? soat,
    Timestamp? tarjetaOp,
    Timestamp? tecnicoMec,
    String? brand,
    String? carPlate,
    String? carType,
    String? model,
    Timestamp? ultCambioAceite,
    Timestamp? proxCambioAceite,
    bool? isFirstTime,
    Map<String, dynamic>? F,
  }) {
    return Car(
      extracto: extracto ?? this.extracto,
      soat: soat ?? this.soat,
      tarjetaOp: tarjetaOp ?? this.tarjetaOp,
      tecnicoMec: tecnicoMec ?? this.tecnicoMec,
      brand: brand ?? this.brand,
      carPlate: carPlate ?? this.carPlate,
      carType: carType ?? this.carType,
      model: model ?? this.model,
      ultCambioAceite: ultCambioAceite ?? this.ultCambioAceite,
      proxCambioAceite: proxCambioAceite ?? this.proxCambioAceite,
      isFirstTime: isFirstTime ?? this.isFirstTime,
      F: F ?? this.F,
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'F.V_extracto': extracto,
      'F.V_soat': soat,
      'F.V_tarjetaOp': tarjetaOp,
      'F.V_tecnicomec': tecnicoMec,
      'brand': brand,
      'carPlate': carPlate,
      'carType': carType,
      'model': model,
      'ultCambioAceite': ultCambioAceite,
      'proxCambioAceite': proxCambioAceite,
      'isFirstTime': isFirstTime,
    };
    if (F != null) {
      map['F'] = F;
    }
    return map;
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      extracto: map['F.V_extracto'],
      soat: map['F.V_soat'],
      tarjetaOp: map['F.V_tarjetaOp'],
      tecnicoMec: map['F.V_tecnicomec'],
      brand: map['brand'] ?? '',
      carPlate: map['carPlate'] ?? '',
      carType: map['carType'] ?? '',
      model: map['model'] ?? '',
      ultCambioAceite: map['ultCambioAceite'],
      proxCambioAceite: map['proxCambioAceite'],
      isFirstTime: map['isFirstTime'],
      F: map['F'] as Map<String, dynamic>?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Car.fromJson(String source) => Car.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Car(extracto: $extracto, soat: $soat, tarjetaOp: $tarjetaOp, tecnicoMec: $tecnicoMec, brand: $brand, carPlate: $carPlate, carType: $carType, model: $model, ultCambioAceite: $ultCambioAceite, proxCambioAceite: $proxCambioAceite, isFirstTime: $isFirstTime, f: $F)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Car &&
        other.extracto == extracto &&
        other.soat == soat &&
        other.tarjetaOp == tarjetaOp &&
        other.tecnicoMec == tecnicoMec &&
        other.brand == brand &&
        other.carPlate == carPlate &&
        other.carType == carType &&
        other.model == model;
  }

  @override
  int get hashCode {
    return extracto.hashCode ^
        soat.hashCode ^
        tarjetaOp.hashCode ^
        tecnicoMec.hashCode ^
        brand.hashCode ^
        carPlate.hashCode ^
        carType.hashCode ^
        model.hashCode;
  }
}
