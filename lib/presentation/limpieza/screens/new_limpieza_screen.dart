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
    final limpieza = ref.watch(newLimpiezaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Chequeo de Limpieza'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(
                limpieza.isOpen 
                  ? Icons.lock_open_rounded 
                  : Icons.lock_rounded,
                color: limpieza.isOpen 
                  ? Colors.green 
                  : Colors.red,
              ),
              onPressed: () {
                ref.read(newLimpiezaProvider.notifier).toggleIsOpen();
                
                // Mostrar SnackBar según el estado
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      limpieza.isOpen 
                        ? 'Cerrando chequeo de limpieza...'
                        : 'Abriendo chequeo de limpieza...',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: !limpieza.isOpen  // Invertido porque el estado aún no se ha actualizado
                        ? Colors.green
                        : Colors.red,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        ],
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
      child: SizedBox(  // Agregamos SizedBox para controlar el tamaño
        height: 60,  // Altura del botón
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
                      SnackBar(
                        content: Text(
                          limpieza.isOpen
                            ? 'Guardando limpieza como abierta...'
                            : 'Guardando limpieza como cerrada...',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: limpieza.isOpen 
                            ? Colors.green 
                            : Colors.red,
                      )
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
                          const SnackBar(
                            content: Text('Limpieza guardada correctamente'),
                            backgroundColor: Colors.blue,
                          )
                        );
                        
                        ref.read(newLimpiezaProvider.notifier).reset();
                        
                        if (context.mounted) {
                          context.pop();
                        }
                      }
                    } catch (excelError) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('La limpieza se guardó pero hubo un error al generar el Excel: $excelError'),
                            backgroundColor: Colors.orange,
                          )
                        );
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
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey;
              }
              return limpieza.isOpen ? Colors.green : Colors.red;
            }),
          ),
          child: isLoading 
            ? const SizedBox(
                width: 30,  // Indicador de carga más grande
                height: 30,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,  // Línea más gruesa
                ),
              )
            : Text(
                limpieza.isOpen 
                  ? 'Guardar Limpieza (Abierta)'
                  : 'Guardar Limpieza (Cerrada)',
                style: const TextStyle(
                  fontSize: 18,  // Texto más grande
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}
