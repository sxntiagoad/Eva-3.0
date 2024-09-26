import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/models/car.dart';
import 'package:eva/providers/car_provider.dart';

class EditCarPage extends ConsumerWidget {
  final String carId;

  const EditCarPage({Key? key, required this.carId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carAsyncValue = ref.watch(selectedCarProvider);
    final carNotifier = ref.read(selectedCarProvider.notifier);

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('cars').doc(carId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(body: Center(child: Text('No se encontró el carro')));
        }

        final carData = snapshot.data!.data() as Map<String, dynamic>;
        final car = Car.fromMap(carData);
        
        if (carAsyncValue == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            carNotifier.setCar(car);
          });
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Editar ${car.brand} ${car.model}'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              TextFormField(
                initialValue: car.brand,
                decoration: const InputDecoration(labelText: 'Marca'),
                onChanged: (value) => carNotifier.updateField('brand', value),
              ),
              TextFormField(
                initialValue: car.model,
                decoration: const InputDecoration(labelText: 'Modelo'),
                onChanged: (value) => carNotifier.updateField('model', value),
              ),
              TextFormField(
                initialValue: car.carPlate,
                decoration: const InputDecoration(labelText: 'Placa'),
                onChanged: (value) => carNotifier.updateField('carPlate', value),
              ),
              TextFormField(
                initialValue: car.carType,
                decoration: const InputDecoration(labelText: 'Tipo de Carro'),
                onChanged: (value) => carNotifier.updateField('carType', value),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectDate(context, ref, 'F.V_extracto', car.extracto),
                child: Text(car.extracto != null ? 'Extracto: ${car.extracto!.toDate().toLocal()}' : 'Seleccionar Fecha de Extracto'),
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context, ref, 'F.V_soat', car.soat),
                child: Text(car.soat != null ? 'SOAT: ${car.soat!.toDate().toLocal()}' : 'Seleccionar Fecha de SOAT'),
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context, ref, 'F.V_tarjetaOp', car.tarjetaOp),
                child: Text(car.tarjetaOp != null ? 'Tarjeta Op: ${car.tarjetaOp!.toDate().toLocal()}' : 'Seleccionar Fecha de Tarjeta Op'),
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context, ref, 'F.V_tecnicomec', car.tecnicoMec),
                child: Text(car.tecnicoMec != null ? 'Tecnico Mec: ${car.tecnicoMec!.toDate().toLocal()}' : 'Seleccionar Fecha de Tecnico Mec'),
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context, ref, 'ultCambioAceite', car.ultCambioAceite),
                child: Text(car.ultCambioAceite != null ? 'Último Cambio de Aceite: ${car.ultCambioAceite!.toDate().toLocal()}' : 'Seleccionar Fecha de Último Cambio de Aceite'),
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context, ref, 'proxCambioAceite', car.proxCambioAceite),
                child: Text(car.proxCambioAceite != null ? 'Próximo Cambio de Aceite: ${car.proxCambioAceite!.toDate().toLocal()}' : 'Seleccionar Fecha de Próximo Cambio de Aceite'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitForm(context, ref, carId),
                child: const Text('Guardar Cambios'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref, String field, Timestamp? currentValue) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentValue?.toDate() ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      ref.read(selectedCarProvider.notifier).updateField(field, Timestamp.fromDate(picked));
    }
  }

  void _submitForm(BuildContext context, WidgetRef ref, String carId) {
    final car = ref.read(selectedCarProvider);
    if (car != null) {
      FirebaseFirestore.instance.collection('cars').doc(carId).update(car.toMap()).then((_) {
        ref.invalidate(mapCarsProvider);
        Navigator.pop(context);
      });
    }
  }
}
