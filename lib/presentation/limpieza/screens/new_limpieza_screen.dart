import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/car_selector.dart';
import '../widgets/list_category.dart';
import '../../../providers/new_limpieza_provider.dart';

class NewLimpiezaScreen extends ConsumerWidget {
  static const name = 'new-limpieza-screen';
  const NewLimpiezaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Limpieza'),
      ),
      body: const Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CustomScrollView(
                slivers: [
                  // Espacio inicial
                  SliverToBoxAdapter(child: SizedBox(height: 16)),
                  
                  // Selector de carro
                  SliverToBoxAdapter(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CarSelector(),
                      ),
                    ),
                  ),
                  
                  // Selector de fecha
                  SliverToBoxAdapter(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: DateSelector(),
                      ),
                    ),
                  ),

                  // Espacio entre selectores y lista
                  SliverToBoxAdapter(child: SizedBox(height: 16)),
                  
                  // Lista de categorías
                  ListCategory(),
                  
                  // Espacio para el botón flotante
                  SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SaveButtonLimpieza(),
    );
  }
}

// Widget para seleccionar la fecha
class DateSelector extends ConsumerWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final limpieza = ref.watch(newLimpiezaProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: () async {
            final fecha = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (fecha != null) {
              ref.read(newLimpiezaProvider.notifier).updateFecha(
                    fecha.toIso8601String(),
                  );
            }
          },
          icon: const Icon(Icons.calendar_today),
          label: Text(
            limpieza.fecha.isEmpty
                ? 'Seleccionar fecha'
                : _formatDate(limpieza.fecha),
          ),
        ),
      ],
    );
  }

  String _formatDate(String isoString) {
    final date = DateTime.parse(isoString);
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Widget para el botón de guardar
class SaveButtonLimpieza extends ConsumerWidget {
  const SaveButtonLimpieza({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isValid = ref.watch(isLimpiezaValidProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FilledButton(
        onPressed: isValid
            ? () {
                // Aquí iría la lógica para guardar la limpieza
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Limpieza guardada correctamente'),
                  ),
                );
              }
            : null,
        child: const Text('Guardar Limpieza'),
      ),
    );
  }
}
