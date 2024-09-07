import 'package:eva/presentation/admin/screens/admin_panel_screen.dart';
import 'package:eva/presentation/home/widgets/logout_show.dart';
import 'package:eva/presentation/user_data/screens/user_data_screen.dart';
import 'package:eva/providers/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CutomDrawer extends ConsumerWidget {
  final GlobalKey<ScaffoldState> drawerKey;
  const CutomDrawer(
    this.drawerKey, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(currentUserProvider);
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 30,
          ),
          userAsyncValue.when(
            data: (data) => Column(
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundImage: NetworkImage(
                    data.photoUrl,
                  ),
                ),
                const SizedBox(height: 10), 
                Text('Rol: ${data.role}'), // Añade esta línea para mostrar el rol
                DrawerItem(
                  drawerKey,
                  icon: Icons.account_circle_outlined,
                  text: 'Datos',
                  navigateTo: UserDataScreen.name,
                ),
                if (data.role == 'ADMIN') // Verifica si el rol del usuario es 'admin'
                  DrawerItem(
                    drawerKey,
                    icon: Icons.admin_panel_settings,
                    text: 'Panel de Administrador',
                    navigateTo: AdminPanelScreen.name,
                  ),
                DrawerItem(
                  drawerKey,
                  icon: Icons.logout_rounded,
                  text: 'Cerrar sesión',
                  onTap: () {
                    if (drawerKey.currentState!.isDrawerOpen) {
                      drawerKey.currentState!.closeDrawer();
                    }
                    showLogoutDialog(context);
                  },
                ),
              ],
            ),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            loading: () => const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final String? navigateTo;
  final GlobalKey<ScaffoldState> drawerKey;
  final void Function()? onTap;
  const DrawerItem(
    this.drawerKey, {
    super.key,
    required this.text,
    required this.icon,
    this.navigateTo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap ??
          () {
            if (navigateTo != null) {
              if (drawerKey.currentState!.isDrawerOpen) {
                drawerKey.currentState!.closeDrawer();
              }
              context.pushNamed(navigateTo!);
            }
          },
    );
  }
}
