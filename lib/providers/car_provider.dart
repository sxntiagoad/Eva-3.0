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
