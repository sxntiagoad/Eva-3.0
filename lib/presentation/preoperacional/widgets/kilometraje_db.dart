import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/preoperacional_db_provider.dart';

class KilometrajeDbWidget extends ConsumerWidget {
  const KilometrajeDbWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildKilometrajeField(
          context,
          ref,
          'Inicial',
          (value) => ref
              .read(preoperacionalDbProvider.notifier)
              .updateKilometrajeInit(value),
        ),
        const SizedBox(width: 16),
        _buildKilometrajeField(
          context,
          ref,
          'Final',
          (value) => ref
              .read(preoperacionalDbProvider.notifier)
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
    final preoperacional = ref.watch(preoperacionalDbProvider);
    final initialValue = label == 'Inicial'
        ? preoperacional.kilometrajeInit.toString()
        : preoperacional.kilometrajeFinal.toString();

    return SizedBox(
      width: 200, // Ancho fijo para ambos campos
      child: TextField(
        controller: TextEditingController(text: initialValue),
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
