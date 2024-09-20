import 'package:eva/providers/car_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_car_page.dart';

class CarManagementPage extends ConsumerWidget {
  static const String name = 'car-management';
  const CarManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carsAsyncValue = ref.watch(mapCarsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Management'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(mapCarsProvider);
        },
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddCarPage()),
                ).then((_) {
                  // Invalidar el provider cuando se regrese de AddCarPage
                  ref.invalidate(mapCarsProvider);
                });
              },
              child: const Text('Add New Car'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: carsAsyncValue.when(
                data: (carsMap) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: carsMap.length,
                    itemBuilder: (context, index) {
                      final car = carsMap.values.elementAt(index);
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Brand: ${car.brand}'),
                              Text('Model: ${car.model}'),
                              Text('Plate: ${car.carPlate}'),
                              Text('Type: ${car.carType}'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}