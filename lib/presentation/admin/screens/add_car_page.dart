import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/providers/car_provider.dart';

class AddCarPage extends ConsumerWidget {
  const AddCarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carForm = ref.watch(carFormProvider);
    final carFormNotifier = ref.read(carFormProvider.notifier);

    Future<void> _selectDate(BuildContext context, String field) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        carFormNotifier.updateField(field, Timestamp.fromDate(picked));
      }
    }

    void _submitForm() {
      FirebaseFirestore.instance.collection('cars').add(carForm.toMap()).then((_) {
        ref.invalidate(mapCarsProvider);
        Navigator.pop(context);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Nuevo Carro'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Marca'),
            onChanged: (value) => carFormNotifier.updateField('brand', value),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Modelo'),
            onChanged: (value) => carFormNotifier.updateField('model', value),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Placa'),
            onChanged: (value) => carFormNotifier.updateField('carPlate', value),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Tipo de Carro'),
            onChanged: (value) => carFormNotifier.updateField('carType', value),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _selectDate(context, 'extracto'),
            child: Text(carForm.extracto != null ? 'Extracto: ${carForm.extracto!.toDate().toLocal()}' : 'Seleccionar Fecha de Extracto'),
          ),
          ElevatedButton(
            onPressed: () => _selectDate(context, 'soat'),
            child: Text(carForm.soat != null ? 'SOAT: ${carForm.soat!.toDate().toLocal()}' : 'Seleccionar Fecha de SOAT'),
          ),
          ElevatedButton(
            onPressed: () => _selectDate(context, 'tarjetaOp'),
            child: Text(carForm.tarjetaOp != null ? 'Tarjeta Op: ${carForm.tarjetaOp!.toDate().toLocal()}' : 'Seleccionar Fecha de Tarjeta Op'),
          ),
          ElevatedButton(
            onPressed: () => _selectDate(context, 'tecnicoMec'),
            child: Text(carForm.tecnicoMec != null ? 'Tecnico Mec: ${carForm.tecnicoMec!.toDate().toLocal()}' : 'Seleccionar Fecha de Tecnico Mec'),
          ),
          ElevatedButton(
            onPressed: () => _selectDate(context, 'ultCambioAceite'),
            child: Text(carForm.ultCambioAceite != null ? 'Último Cambio de Aceite: ${carForm.ultCambioAceite!.toDate().toLocal()}' : 'Seleccionar Fecha de Último Cambio de Aceite'),
          ),
          ElevatedButton(
            onPressed: () => _selectDate(context, 'proxCambioAceite'),
            child: Text(carForm.proxCambioAceite != null ? 'Próximo Cambio de Aceite: ${carForm.proxCambioAceite!.toDate().toLocal()}' : 'Seleccionar Fecha de Próximo Cambio de Aceite'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Guardar Carro'),
          ),
        ],
      ),
    );
  }
}