import 'package:eva/providers/car_provider.dart';
import 'package:eva/providers/new_limpieza_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CarSelector extends ConsumerWidget {
  const CarSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observa el carId seleccionado del estado de limpieza
    final selectedCar = ref.watch(newLimpiezaProvider).carId;
    // Observa la lista de carros disponibles
    final carsProvider = ref.watch(mapCarsProvider);

    return carsProvider.when(
      data: (data) => DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Seleccione un carro',
        ),
        value: selectedCar.isEmpty ? null : selectedCar,
        items: data.entries
            .map(
              (e) => DropdownMenuItem(
                value: e.key,
                child: Text(e.value.carPlate),
              ),
            )
            .toList(),
        onChanged: (value) {
          // Actualiza el carId en el estado de limpieza
          ref.read(newLimpiezaProvider.notifier).updateCarId(value ?? '');
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
