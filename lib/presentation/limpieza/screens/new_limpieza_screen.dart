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
    final isSaving = ref.watch(saveLimpiezaProvider).isLoading;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FilledButton(
        onPressed: limpieza.carId.isEmpty || isSaving
            ? null
            : () async {
                try {
                  // Mostrar indicador de carga
                  ref.read(saveLimpiezaProvider);
                  
                  // Guardar en Firebase
                  await ref.read(newLimpiezaProvider.notifier).saveLimpieza();
                  
                  if (context.mounted) {
                    // Mostrar mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Limpieza guardada correctamente'),
                      ),
                    );
                    
                    // Resetear el formulario
                    ref.read(newLimpiezaProvider.notifier).reset();
                    
                    // Volver atrás
                    context.pop();
                  }
                } catch (e) {
                  // Mostrar error
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al guardar: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
        child: isSaving 
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('Guardar Limpieza'),
      ),
    );
  }
}
