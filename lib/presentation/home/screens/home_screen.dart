import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../core/theme/app_theme.dart';
import '../../../providers/current_user_provider.dart';
import '../../list_preoperacionales.dart/screens/list_preoperacionales_screen.dart';
import '../../new_preoperacional/screens/new_preoperacional_scree.dart';
import '../widgets/custom_drawer.dart';

// Definir un provider para manejar la lista de archivos
final archivosProvider = FutureProvider<List<String>>((ref) async {
  FirebaseStorage storage = FirebaseStorage.instanceFor(
    bucket: 'eva-project-91804.appspot.com', // Reemplaza con tu bucket real
  );
  ListResult resultado = await storage.ref('preoperacionales/').listAll();
  return resultado.items.map((item) => item.name).toList();
});

class HomeScreen extends ConsumerWidget {
  static const name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final userAsyncValue = ref.watch(currentUserProvider);
    final archivosAsyncValue = ref.watch(archivosProvider);

    return userAsyncValue.when(
      data: (data) {
        return Scaffold(
          key: scaffoldKey,
          drawer: CutomDrawer(scaffoldKey),
          appBar: AppBar(
            leadingWidth: 72,
            title: Text(data.fullName),
            leading: Container(
              margin: const EdgeInsets.only(left: .0),
              child: GestureDetector(
                onTap: () {
                  // context.pushNamed(UserDataScreen.name);
                  scaffoldKey.currentState!.openDrawer();
                },
                child: Hero(
                  tag: data.photoUrl,
                  child: CircleAvatar(
                    radius: 56,
                    backgroundImage: NetworkImage(
                      data.photoUrl,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Selecciona lo que deseas hacer',
                style: TextStyle(
                  color: AppTheme.mainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const _CustomButton(
                icon: Icons.article_outlined,
                text: 'Generar nuevo preoperacional',
                navigateTo: NewPreoperacionalScree.name,
              ),
              const _CustomButton(
                icon: Icons.article_outlined,
                text: 'Editar preoperacional ya existente',
                navigateTo: ListPreoperacionalesScreen.name,
              ),
              const SizedBox(height: 20),
              // Sección para listar archivos
              Expanded(
                child: archivosAsyncValue.when(
                  data: (archivos) {
                    if (archivos.isEmpty) {
                      return const Center(child: Text('No se encontraron archivos.'));
                    }
                    return ListView.builder(
                      itemCount: archivos.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.insert_drive_file),
                          title: Text(archivos[index]),
                          onTap: () {
                            // Manejar la acción al tocar el archivo, como descargarlo o abrirlo.
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class _CustomButton extends StatelessWidget {
  final String navigateTo;
  final IconData icon;
  final String text;

  const _CustomButton({
    required this.navigateTo,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(navigateTo);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16).copyWith(bottom: 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.mainColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const Spacer(),
            Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
