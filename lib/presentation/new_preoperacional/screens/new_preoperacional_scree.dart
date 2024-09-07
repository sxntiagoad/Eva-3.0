import 'package:eva/providers/is_open.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/carplate.dart';
import '../widgets/inspecciones/list_category.dart';
import '../widgets/save_widget.dart';
import '../widgets/type_kid_widget.dart';

class NewPreoperacionalScree extends ConsumerWidget {
  static const name = 'new-preoperacional-screen';
  const NewPreoperacionalScree({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = ref.watch(isOpenProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo preoperacional'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(isOpenProvider.notifier).state = !isOpen;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Guardar y ${isOpen ? 'CERRAR' : 'dejar ABIERTO'}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: isOpen ? Colors.red : Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: isOpen
                ? const Icon(
                    Icons.lock_open,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.red,
                  ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: const [
            SizedBox(height: 10),
            CarPlate(),
            SizedBox(height: 10),
            TypeKidWidget(),
            SizedBox(height: 10),
            ListCategory(),
            SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SaveWidget(),
      ),
    );
  }
}
