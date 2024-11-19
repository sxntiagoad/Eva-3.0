import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

                  // Espacio entre selector y lista
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

class SaveButtonLimpieza extends ConsumerWidget {
  const SaveButtonLimpieza({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final limpieza = ref.watch(newLimpiezaProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FilledButton(
        onPressed: limpieza.carId.isEmpty
            ? null
            : () {
                // Aquí iría la lógica para guardar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Limpieza guardada correctamente'),
                  ),
                );
                ref.read(newLimpiezaProvider.notifier).reset();
                context.pop();
              },
        child: const Text('Guardar Limpieza'),
      ),
    );
  }
}
