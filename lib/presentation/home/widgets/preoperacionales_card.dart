import 'package:eva/core/theme/app_theme.dart';
import 'package:eva/models/car.dart';
import 'package:eva/presentation/preoperacional/screens/preoperacional_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/preoperacional.dart';
import '../../../providers/car_provider.dart';

class PreoperacionalesCard extends ConsumerWidget {
  final Preoperacional preoperacional;
  const PreoperacionalesCard({
    super.key,
    required this.preoperacional,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapCars = ref.watch(mapCarsProvider);
    return mapCars.when(
      data: (data) => _ListTitlePreoperacional(
        preoperacional: preoperacional,
        data: data,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class _ListTitlePreoperacional extends StatelessWidget {
  final Preoperacional preoperacional;
  final Map<String, Car> data;
  const _ListTitlePreoperacional({
    required this.preoperacional,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '${data[preoperacional.carId]?.carPlate ?? ''} - ${data[preoperacional.carId]?.brand ?? ''}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppTheme.mainColor,
        ),
      ),
      subtitle: Text(preoperacional.fechaInit),
      trailing: preoperacional.isOpen
          ? const Icon(
              Icons.lock_open_outlined,
              color: Colors.green,
            )
          : const Icon(
              Icons.lock,
              color: Colors.red,
            ),
      onTap: () {
        context.pushNamed(
          PreoperacionalScreen.name,
          extra: preoperacional,
        );
      },
    );
  }
}
