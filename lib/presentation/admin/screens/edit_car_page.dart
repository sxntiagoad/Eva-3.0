import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva/models/car.dart';
import 'package:eva/providers/car_provider.dart';

class EditCarPage extends ConsumerStatefulWidget {
  final String carId;

  const EditCarPage({Key? key, required this.carId}) : super(key: key);

  @override
  _EditCarPageState createState() => _EditCarPageState();
}

class _EditCarPageState extends ConsumerState<EditCarPage> {
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _loadCar();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _loadCar() async {
    if (_isDisposed) return;
    // Clear any previously loaded car data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed) {
        ref.read(selectedCarProvider.notifier).setCar(null);
      }
    });
    
    final carDoc = await FirebaseFirestore.instance.collection('cars').doc(widget.carId).get();
    if (carDoc.exists && !_isDisposed) {
      final car = Car.fromMap(carDoc.data()!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed) {
          ref.read(selectedCarProvider.notifier).setCar(car);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final carAsyncValue = ref.watch(selectedCarProvider);
    final carNotifier = ref.read(selectedCarProvider.notifier);

    if (carAsyncValue == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar ${carAsyncValue.brand} ${carAsyncValue.model}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextFormField(
            initialValue: carAsyncValue.brand,
            decoration: const InputDecoration(labelText: 'Marca'),
            onChanged: (value) => carNotifier.updateField('brand', value),
          ),
          TextFormField(
            initialValue: carAsyncValue.model,
            decoration: const InputDecoration(labelText: 'Modelo'),
            onChanged: (value) => carNotifier.updateField('model', value),
          ),
          TextFormField(
            initialValue: carAsyncValue.carPlate,
            decoration: const InputDecoration(labelText: 'Placa'),
            onChanged: (value) => carNotifier.updateField('carPlate', value),
          ),
          TextFormField(
            initialValue: carAsyncValue.carType,
            decoration: const InputDecoration(labelText: 'Tipo de Carro'),
            onChanged: (value) => carNotifier.updateField('carType', value),
          ),
          const SizedBox(height: 20),
          _buildDateButton('extracto', 'Extracto', carAsyncValue.extracto),
          _buildDateButton('soat', 'SOAT', carAsyncValue.soat),
          _buildDateButton('tarjetaOp', 'Tarjeta de Operación', carAsyncValue.tarjetaOp),
          _buildDateButton('tecnicoMec', 'Técnico Mecánica', carAsyncValue.tecnicoMec),
          _buildDateButton('ultCambioAceite', 'Último Cambio de Aceite', carAsyncValue.ultCambioAceite),
          _buildDateButton('proxCambioAceite', 'Próximo Cambio de Aceite', carAsyncValue.proxCambioAceite),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _submitForm(context, ref, widget.carId),
            child: const Text('Guardar Cambios'),
          ),
        ],
      ),
    );
  }

  Widget _buildDateButton(String field, String label, Timestamp? currentValue) {
    return ElevatedButton(
      onPressed: () => _selectDate(context, field, currentValue),
      child: Text(currentValue != null
          ? '$label: ${currentValue.toDate().toLocal()}'
          : 'Seleccionar Fecha de $label'),
    );
  }

  Future<void> _selectDate(BuildContext context, String field, Timestamp? currentValue) async {
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
    if (_isDisposed) return;
    final carNotifier = ref.read(selectedCarProvider.notifier);
    final car = ref.read(selectedCarProvider);
    if (car != null) {
      FirebaseFirestore.instance
          .collection('cars')
          .doc(carId)
          .update(car.toMap())
          .then((_) {
        if (!_isDisposed) {
          ref.invalidate(mapCarsProvider);
          Navigator.pop(context);
        }
      });
    }
  }
}