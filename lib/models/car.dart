import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  final Timestamp ?extracto;
  final Timestamp ?soat;
  final Timestamp ?tarjetaOp;
  final Timestamp ?tecnicoMec;

  final String brand;
  final String carPlate;
  final String carType;
  final String model;
  Car({
    required this.extracto,
    required this.soat,
    required this.tarjetaOp,
    required this.tecnicoMec,
    required this.brand,
    required this.carPlate,
    required this.carType,
    required this.model,
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'F.V_extracto': extracto,
      'F.V_soat': soat,
      'F.V_tarjetaOp': tarjetaOp,
      'F.V_tecnicomec': tecnicoMec,

      'brand': brand,
      'carPlate': carPlate,
      'carType': carType,
      'model': model,
    };
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
    );
  }

  String toJson() => json.encode(toMap());

  factory Car.fromJson(String source) => Car.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Car(extracto: $extracto, soat: $soat, tarjetaOp: $tarjetaOp, tecnicoMec: $tecnicoMec, brand: $brand, carPlate: $carPlate, carType: $carType, model: $model)';
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