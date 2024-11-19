import 'package:eva/core/excel/limpieza_generator.dart';
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
        title: const Text('Nuevo Chequeo de Limpieza'),
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

class SaveButtonLimpieza extends ConsumerStatefulWidget {
  const SaveButtonLimpieza({super.key});

  @override
  SaveButtonLimpiezaState createState() => SaveButtonLimpiezaState();
}

class SaveButtonLimpiezaState extends ConsumerState<SaveButtonLimpieza> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final limpieza = ref.watch(newLimpiezaProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FilledButton(
        onPressed: limpieza.carId.isEmpty || isLoading
            ? null
            : () async {
                setState(() {
                  isLoading = true;
                });
                
                try {
                  // Mostrar indicador de carga
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Guardando limpieza...'))
                  );

                  final docId = await ref.read(newLimpiezaProvider.notifier).saveLimpieza() ?? '';
                  
                  try {
                    await limpiezaDataJson(
                      ref: ref,
                      limpieza: ref.read(newLimpiezaProvider),
                      idDoc: docId,
                    );
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Limpieza guardada correctamente'))
                      );
                      
                      // Resetear el formulario
                      ref.read(newLimpiezaProvider.notifier).reset();
                      
                      // Navegar hacia atrás
                      if (context.mounted) {
                        context.pop();
                      }
                    }
                  } catch (excelError) {
                    // Si falla el Excel, al menos la limpieza se guardó
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('La limpieza se guardó pero hubo un error al generar el Excel: $excelError'),
                          backgroundColor: Colors.orange,
                        )
                      );
                      // Aún así navegamos hacia atrás ya que la limpieza se guardó
                      context.pop();
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al guardar: $e'),
                        backgroundColor: Colors.red,
                      )
                    );
                  }
                } finally {
                  if (mounted) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                }
              },
        child: isLoading 
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text('Guardar Limpieza'),
      ),
    );
  }
}
