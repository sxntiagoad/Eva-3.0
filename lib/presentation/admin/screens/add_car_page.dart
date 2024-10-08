import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/models/car.dart';
import 'package:eva/providers/car_provider.dart';

class AddCarPage extends ConsumerStatefulWidget {
  const AddCarPage({Key? key}) : super(key: key);

  @override
  _AddCarPageState createState() => _AddCarPageState();
}

class _AddCarPageState extends ConsumerState<AddCarPage> {
  late Car newCar;

  @override
  void initState() {
    super.initState();
    newCar = Car(
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
    );
  }

  @override
  Widget build(BuildContext context) {
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
            onChanged: (value) => setState(() => newCar = newCar.copyWith(brand: value)),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Modelo'),
            onChanged: (value) => setState(() => newCar = newCar.copyWith(model: value)),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Placa'),
            onChanged: (value) => setState(() => newCar = newCar.copyWith(carPlate: value)),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Tipo de Carro'),
            onChanged: (value) => setState(() => newCar = newCar.copyWith(carType: value)),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _selectDate(context, 'extracto'),
            child: Text(newCar.extracto != null ? 'Extracto: ${newCar.extracto!.toDate().toLocal()}' : 'Seleccionar Fecha de Extracto'),
          ),
          ElevatedButton(
            onPressed: () => _selectDate(context, 'soat'),
            child: Text(newCar.soat != null ? 'SOAT: ${newCar.soat!.toDate().toLocal()}' : 'Seleccionar Fecha de SOAT'),
          ),
          ElevatedButton(
            onPressed: () => _selectDate(context, 'tarjetaOp'),
            child: Text(newCar.tarjetaOp != null ? 'Tarjeta de Operación: ${newCar.tarjetaOp!.toDate().toLocal()}' : 'Seleccionar Fecha de Tarjeta de Operación'),
          ),
          ElevatedButton(
            onPressed: () => _selectDate(context, 'tecnicoMec'),
            child: Text(newCar.tecnicoMec != null ? 'Técnico Mecánica: ${newCar.tecnicoMec!.toDate().toLocal()}' : 'Seleccionar Fecha de Técnico Mecánica'),
          ),
          ElevatedButton(
            onPressed: () => _selectDate(context, 'ultCambioAceite'),
            child: Text(newCar.ultCambioAceite != null ? 'Último Cambio de Aceite: ${newCar.ultCambioAceite!.toDate().toLocal()}' : 'Seleccionar Fecha de Último Cambio de Aceite'),
          ),
          ElevatedButton(
            onPressed: () => _selectDate(context, 'proxCambioAceite'),
            child: Text(newCar.proxCambioAceite != null ? 'Próximo Cambio de Aceite: ${newCar.proxCambioAceite!.toDate().toLocal()}' : 'Seleccionar Fecha de Próximo Cambio de Aceite'),
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
            newCar = newCar.copyWith(extracto: Timestamp.fromDate(picked));
            break;
          case 'soat':
            newCar = newCar.copyWith(soat: Timestamp.fromDate(picked));
            break;
          case 'tarjetaOp':
            newCar = newCar.copyWith(tarjetaOp: Timestamp.fromDate(picked));
            break;
          case 'tecnicoMec':
            newCar = newCar.copyWith(tecnicoMec: Timestamp.fromDate(picked));
            break;
          case 'ultCambioAceite':
            newCar = newCar.copyWith(ultCambioAceite: Timestamp.fromDate(picked));
            break;
          case 'proxCambioAceite':
            newCar = newCar.copyWith(proxCambioAceite: Timestamp.fromDate(picked));
            break;
        }
      });
    }
  }

  void _submitForm() {
    FirebaseFirestore.instance.collection('cars').add(newCar.toMap()).then((_) {
      ref.invalidate(mapCarsProvider);
      Navigator.pop(context);
    });
  }
}