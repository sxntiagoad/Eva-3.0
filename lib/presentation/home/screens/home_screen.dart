import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../providers/current_user_provider.dart';
import '../../list_preoperacionales.dart/screens/list_preoperacionales_screen.dart';
import '../../new_preoperacional/screens/new_preoperacional_scree.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends ConsumerWidget {
  static const name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final userAsyncValue = ref.watch(currentUserProvider);

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
          body: const Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Selecciona lo que deseas hacer',
                style: TextStyle(
                  color: AppTheme.mainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              _CustomButton(
                icon: Icons.article_outlined,
                text: 'Generar nuevo preoperacional',
                navigateTo: NewPreoperacionalScree.name,
              ),
              _CustomButton(
                icon: Icons.article_outlined,
                text: 'Editar preoperacional ya existente',
                navigateTo: ListPreoperacionalesScreen.name,
              )
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
