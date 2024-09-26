import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/new_preoperacional_provider.dart';

class KilometrajeWidget extends ConsumerWidget {
  const KilometrajeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildKilometrajeField(
          context,
          ref,
          'Inicial',
          (value) => ref
              .read(newPreoperacionalProvider.notifier)
              .updateKilometrajeInit(value),
        ),
        const SizedBox(width: 55),
        _buildKilometrajeField(
          context,
          ref,
          'Final',
          (value) => ref
              .read(newPreoperacionalProvider.notifier)
              .updateKilometrajeFinal(value),
        ),
      ],
    );
  }

  Widget _buildKilometrajeField(
    BuildContext context,
    WidgetRef ref,
    String label,
    Function(int) onChanged,
  ) {
    return SizedBox(
      width: 200, // Ancho fijo para ambos campos
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Kilometraje $label',
        ),
        onChanged: (value) {
          final kilometraje = int.tryParse(value) ?? 0;
          onChanged(kilometraje);
        },
      ),
    );
  }
}
