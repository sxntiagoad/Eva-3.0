import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart ';

import '../models/car.dart';


Future<Map<String, Car>> getAllCars() async {
  final firestore = FirebaseFirestore.instance;
  final Map<String, Car> carsMap = {};
  
  try {
    final snapshot = await firestore.collection('cars').get();
    for (var doc in snapshot.docs) {
      final carData = Car.fromMap(doc.data());
      carsMap[doc.id] = carData;
    }
  } catch (e) {
    rethrow;
  }
  
  return carsMap;
}


final mapCarsProvider = FutureProvider<Map<String, Car>>((ref) async {
  return await getAllCars();
});

final carFormProvider = StateNotifierProvider<CarFormNotifier, Car>((ref) {
  return CarFormNotifier();
});

class CarFormNotifier extends StateNotifier<Car> {
  CarFormNotifier() : super(Car(
    extracto: null,
    soat: null,
    tarjetaOp: null,
    tecnicoMec: null,
    brand: '',
    carPlate: '',
    carType: '',
    model: '',
    ultCambioAceite: null,
    proxCambioAceite: null,
  ));

  void updateField(String field, dynamic value) {
    state = state.copyWith(
      extracto: field == 'extracto' ? value : state.extracto,
      soat: field == 'soat' ? value : state.soat,
      tarjetaOp: field == 'tarjetaOp' ? value : state.tarjetaOp,
      tecnicoMec: field == 'tecnicoMec' ? value : state.tecnicoMec,
      brand: field == 'brand' ? value : state.brand,
      carPlate: field == 'carPlate' ? value : state.carPlate,
      carType: field == 'carType' ? value : state.carType,
      model: field == 'model' ? value : state.model,
      ultCambioAceite: field == 'ultCambioAceite' ? value : state.ultCambioAceite,
      proxCambioAceite: field == 'proxCambioAceite' ? value : state.proxCambioAceite,
    );
  }
}

final selectedCarProvider = StateNotifierProvider<SelectedCarNotifier, Car?>((ref) {
  return SelectedCarNotifier();
});

class SelectedCarNotifier extends StateNotifier<Car?> {
  SelectedCarNotifier() : super(null);

  void setCar(Car car) {
    state = car;
  }

  void updateField(String field, dynamic value) {
    if (state == null) return;
    state = state!.copyWith(
      extracto: field == 'F.V_extracto' ? value : state!.extracto,
      soat: field == 'F.V_soat' ? value : state!.soat,
      tarjetaOp: field == 'F.V_tarjetaOp' ? value : state!.tarjetaOp,
      tecnicoMec: field == 'F.V_tecnicomec' ? value : state!.tecnicoMec,
      brand: field == 'brand' ? value : state!.brand,
      carPlate: field == 'carPlate' ? value : state!.carPlate,
      carType: field == 'carType' ? value : state!.carType,
      model: field == 'model' ? value : state!.model,
      ultCambioAceite: field == 'ultCambioAceite' ? value : state!.ultCambioAceite,
      proxCambioAceite: field == 'proxCambioAceite' ? value : state!.proxCambioAceite,
    );
  }
}
