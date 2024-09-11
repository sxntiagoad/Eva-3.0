import 'package:eva/core/theme/app_theme.dart';
import 'package:eva/presentation/user_data/widgets/signature.dart';
import 'package:eva/presentation/user_data/widgets/user_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../providers/current_user_provider.dart';

class UserDataScreen extends ConsumerWidget {
  static const name = 'user-data-screen';
  const UserDataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(currentUserProvider);
    final currentUser = FirebaseAuth.instance.currentUser;

    return userAsyncValue.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(body: Center(child: Text('Error: $error'))),
      data: (data) {
        if (currentUser == null) {
          return const Scaffold(body: Center(child: Text('No hay usuario autenticado')));
        }
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
                    controller: TextEditingController(text: data.fullName),
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo',
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: TextEditingController(text: data.email),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: TextEditingController(text: data.role),
                    decoration: const InputDecoration(
                      labelText: 'Cargo',
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  SignatureWidget(key: ValueKey(currentUser.uid), initialSignatureUrl: data.signature),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.mainColor),
              onPressed: () {
                // Lógica para modificar otros datos
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
}