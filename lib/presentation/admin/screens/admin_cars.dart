import 'package:eva/presentation/admin/screens/preoperacionales_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eva/providers/car_provider.dart';
import 'package:eva/core/theme/app_theme.dart';
import 'package:eva/presentation/admin/screens/car_pos.dart';

class AdminCars extends ConsumerWidget {
  static const String name = 'admin-cars';

  const AdminCars({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carsAsyncValue = ref.watch(mapCarsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Carros'),
      ),
      body: Center(
        child: carsAsyncValue.when(
          data: (carsMap) {
            final cars = carsMap.values.toList();
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarPos(car: car),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        car.carPlate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
      ),
    );
  }
}
