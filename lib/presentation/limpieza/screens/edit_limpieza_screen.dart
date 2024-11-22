import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../models/limpieza.dart';
import '../../../providers/limpieza/limpieza_db_provider.dart';
import '../widgets/car_selector.dart';
import '../widgets/list_category.dart';
import '../../../core/excel/limpieza_generator.dart';

class EditLimpiezaScreen extends ConsumerStatefulWidget {
  final Limpieza limpieza;
  static const name = 'edit-limpieza-screen';
  
  const EditLimpiezaScreen({
    required this.limpieza,
    super.key,
  });

  @override
  ConsumerState<EditLimpiezaScreen> createState() => _EditLimpiezaScreenState();
}

class _EditLimpiezaScreenState extends ConsumerState<EditLimpiezaScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Print para ver los datos que llegan inicialmente
    print('EditLimpiezaScreen - Datos iniciales:');
    print('DocId: ${widget.limpieza.docId}');
    print('CarId: ${widget.limpieza.carId}');
    print('Fecha: ${widget.limpieza.fecha}');
    print('IsOpen: ${widget.limpieza.isOpen}');
    print('Inspecciones: ${widget.limpieza.inspecciones}');
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Print antes de reemplazar
      print('Antes de replaceLimpieza:');
      final currentState = ref.read(limpiezaDbProvider);
      print('Estado actual: $currentState');
      
      ref.read(limpiezaDbProvider.notifier).replaceLimpieza(widget.limpieza);
      
      // Print después de reemplazar
      print('Después de replaceLimpieza:');
      final newState = ref.read(limpiezaDbProvider);
      print('Nuevo estado: $newState');
    });
  }

  @override
  Widget build(BuildContext context) {
    final limpieza = ref.watch(limpiezaDbProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Limpieza'),
        actions: [
          IconButton(
            icon: Icon(
              limpieza.isOpen ? Icons.lock_open : Icons.lock,
              color: limpieza.isOpen ? Colors.green : Colors.red,
            ),
            onPressed: () {
              ref.read(limpiezaDbProvider.notifier).updateIsOpen(!limpieza.isOpen);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    limpieza.isOpen ? 'Cerrando limpieza...' : 'Abriendo limpieza...',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: !limpieza.isOpen ? Colors.green : Colors.red,
                ),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CarSelector(
                    selectedCarId: limpieza.carId,
                    onCarSelected: (carId) {
                      ref.read(limpiezaDbProvider.notifier).updateCarId(carId);
                    },
                  ),
                ),
              ),
            ),
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
          
          ListCategory(
            inspecciones: limpieza.inspecciones,
            onUpdateInspeccion: (category, day, value) {
              ref.read(limpiezaDbProvider.notifier).updateInspeccion(category, day, value);
            },
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 60,
          child: FilledButton(
            onPressed: isLoading ? null : () async {
              setState(() => isLoading = true);
              try {
                // Primero actualizamos en Firebase
                await ref.read(limpiezaDbProvider.notifier).updateLimpiezaInFirebase();
                
                // Luego actualizamos el archivo Excel
                try {
                  await limpiezaDataJson(
                    ref: ref,
                    limpieza: ref.read(limpiezaDbProvider),
                    idDoc: widget.limpieza.docId,
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Limpieza actualizada correctamente'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                    context.pop();
                  }
                } catch (excelError) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'La limpieza se actualizó pero hubo un error al actualizar el Excel: $excelError'
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    context.pop();
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al actualizar: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } finally {
                if (mounted) setState(() => isLoading = false);
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.disabled)) return Colors.grey;
                return limpieza.isOpen ? Colors.green : Colors.red;
              }),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : Text(
                    limpieza.isOpen ? 'Actualizar (Abierta)' : 'Actualizar (Cerrada)',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}