import 'package:eva/presentation/preoperacional/widgets/inspeccion_db/list_category_db.dart';
import 'package:eva/presentation/preoperacional/widgets/uptate_preoperacional.dart';
import 'package:eva/providers/is_open.dart';
import 'package:eva/providers/preoperacionales_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/preoperacional.dart';
import '../../../providers/preoperacional_db_provider.dart';
import '../widgets/car_plate_db.dart';

import '../widgets/type_kid_db.dart';

class PreoperacionalScreen extends ConsumerStatefulWidget {
  final Preoperacional preoperacional;
  static const name = 'preoperacional-screen';
  const PreoperacionalScreen({
    required this.preoperacional,
    super.key,
  });

  @override
  ConsumerState<PreoperacionalScreen> createState() =>
      _PreoperacionalScreenState();
}

class _PreoperacionalScreenState extends ConsumerState<PreoperacionalScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(preoperacionalDbProvider.notifier)
          .replacePreoperacional(widget.preoperacional);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = ref.watch(isOpenProvider);
    return PopScope(
      onPopInvoked: (didPop) {
        ref.invalidate(allPreoperacionalesProvider);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Preoperacional'),
          actions: [
            IconButton(
              onPressed: () {
                ref.read(isOpenProvider.notifier).state = !isOpen;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Actualizar y ${isOpen ? 'CERRAR' : 'dejar ABIERTO'}',
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
              CarPlateDb(),
              SizedBox(
                height: 15,
              ),
              TypeKidDbWidget(),
              SizedBox(
                height: 10,
              ),
              Divider(),
              ListCategoryDb(),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: UpdatePreoperacional(),
        ),
      ),
    );
  }
}
