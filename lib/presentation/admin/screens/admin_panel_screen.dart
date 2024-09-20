import 'package:eva/presentation/admin/screens/car_management_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import './admin_cars.dart'; // Asegúrate de importar la clase AdminCars

class AdminPanelScreen extends ConsumerWidget {
  static const String name = 'admin-panel';

  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Asegura que todo esté centrado horizontalmente
        children: [
          SizedBox(height: 20),  // Controla la distancia entre el AppBar y el contenido
          Center( // Centra horizontalmente el texto
            child: Text(
              'Selecciona una opción',
              style: TextStyle(
                color: AppTheme.mainColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 40),  // Aumenta o disminuye esta altura para ajustar la posición vertical del botón
          Center(  // Centra horizontalmente el contenido
            child: Column(
              children: [
                CustomButton(
                  icon: Icons.directions_car,
                  text: 'Preoperacionales',
                  navigateTo: AdminCars.name,
                ),
                CustomButton(
                  icon: Icons.directions_car,
                  text: 'Gestionar Carros',
                  navigateTo: CarManagementPage.name,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String navigateTo;
  final IconData icon;
  final String text;

  const CustomButton({
    super.key,
    required this.navigateTo,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/$navigateTo'); // Navega a la ruta especificada
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8, // 80% del ancho de la pantalla
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppTheme.mainColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}