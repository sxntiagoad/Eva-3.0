import 'package:eva/providers/car_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/models/car.dart';

class AddCarPage extends ConsumerWidget {
  const AddCarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _AddCarPageContent(ref: ref);
  }
}

class _AddCarPageContent extends StatefulWidget {
  final WidgetRef ref;

  const _AddCarPageContent({required this.ref, Key? key}) : super(key: key);

  @override
  _AddCarPageContentState createState() => _AddCarPageContentState();
}

class _AddCarPageContentState extends State<_AddCarPageContent> {
  final _formKey = GlobalKey<FormState>();
  late String brand, carPlate, carType, model;
  DateTime? extracto, soat, tarjetaOp, tecnicoMec;

  Future<void> _selectDate(BuildContext context, String field) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        switch (field) {
          case 'extracto':
            extracto = picked;
            break;
          case 'soat':
            soat = picked;
            break;
          case 'tarjetaOp':
            tarjetaOp = picked;
            break;
          case 'tecnicoMec':
            tecnicoMec = picked;
            break;
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final car = Car(
        extracto: extracto != null ? Timestamp.fromDate(extracto!) : null,
        soat: soat != null ? Timestamp.fromDate(soat!) : null,
        tarjetaOp: tarjetaOp != null ? Timestamp.fromDate(tarjetaOp!) : null,
        tecnicoMec: tecnicoMec != null ? Timestamp.fromDate(tecnicoMec!) : null,
        brand: brand,
        carPlate: carPlate,
        carType: carType,
        model: model,
      );
      FirebaseFirestore.instance.collection('cars').add(car.toMap()).then((_) {
        // Invalidar el provider después de agregar el carro
        widget.ref.invalidate(mapCarsProvider);
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Car'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Brand'),
              validator: (value) => value!.isEmpty ? 'Please enter a brand' : null,
              onSaved: (value) => brand = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Model'),
              validator: (value) => value!.isEmpty ? 'Please enter a model' : null,
              onSaved: (value) => model = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Car Plate'),
              validator: (value) => value!.isEmpty ? 'Please enter a car plate' : null,
              onSaved: (value) => carPlate = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Car Type'),
              validator: (value) => value!.isEmpty ? 'Please enter a car type' : null,
              onSaved: (value) => carType = value!,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context, 'extracto'),
              child: Text(extracto != null ? 'Extracto: ${extracto!.toLocal()}' : 'Select Extracto Date'),
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context, 'soat'),
              child: Text(soat != null ? 'SOAT: ${soat!.toLocal()}' : 'Select SOAT Date'),
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context, 'tarjetaOp'),
              child: Text(tarjetaOp != null ? 'Tarjeta Op: ${tarjetaOp!.toLocal()}' : 'Select Tarjeta Op Date'),
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context, 'tecnicoMec'),
              child: Text(tecnicoMec != null ? 'Tecnico Mec: ${tecnicoMec!.toLocal()}' : 'Select Tecnico Mec Date'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Save Car'),
            ),
          ],
        ),
      ),
    );
  }
}