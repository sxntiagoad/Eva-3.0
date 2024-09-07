import 'package:eva/core/theme/app_theme.dart';
import 'package:eva/presentation/user_data/widgets/user_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/current_user_provider.dart';

class UserDataScreen extends ConsumerStatefulWidget {
  static const name = 'user-data-screen';
  const UserDataScreen({super.key});

  @override
  UserDataScreenState createState() => UserDataScreenState();
}

class UserDataScreenState extends ConsumerState<UserDataScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _cargoController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _cargoController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(currentUserProvider);

    return userAsyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (data) {
        // Actualiza los controladores con los datos del usuario
        _nameController.text = data.fullName;
        _emailController.text = data.email;
        _cargoController.text = data.role;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Datos personales'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const UserPhoto(),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _cargoController,
                    decoration: const InputDecoration(
                      labelText: 'Cargo',
                    ),
                    enabled: false,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppTheme.mainColor),
              onPressed: () {
                // Aquí puedes manejar la lógica para actualizar los datos
                // print('Nombre: ${_nameController.text}');
                // print('Email: ${_emailController.text}');
              },
              child: const Text(
                'Modificar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cargoController.dispose();
    super.dispose();
  }
}
