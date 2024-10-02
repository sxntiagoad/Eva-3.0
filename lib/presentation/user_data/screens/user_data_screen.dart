import 'package:eva/providers/edit_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/signature.dart';
import '../widgets/user_photo.dart';

class UserDataScreen extends ConsumerStatefulWidget {
  static const name = 'user-data-screen';
  const UserDataScreen({super.key});

  @override
  _UserDataScreenState createState() => _UserDataScreenState();
}

class _UserDataScreenState extends ConsumerState<UserDataScreen> {
  @override
  Widget build(BuildContext context) {
    final userDataNotifier = ref.watch(userDataProvider.notifier);
    final userData = ref.watch(userDataProvider);
    final isEditing = userDataNotifier.isEditing;

    if (userData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
              _buildTextField('Nombre completo', userData.fullName, isEditing,
                  (value) => userDataNotifier.updateField('fullName', value)),
              const SizedBox(height: 20),
              _buildTextField('Email', userData.email, isEditing,
                  (value) => userDataNotifier.updateField('email', value)),
              const SizedBox(height: 20),
              _buildReadOnlyField('Cargo', userData.role),
              const SizedBox(height: 20),
              SignatureWidget(
                key: ValueKey(userData.email),
                initialSignatureUrl: userData.signature,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isEditing ? Colors.blue[900] : AppTheme.mainColor,
          ),
          onPressed: () {
            if (isEditing) {
              userDataNotifier.saveChanges();
            } else {
              userDataNotifier.toggleEditing();
            }
          },
          child: Text(
            isEditing ? 'Guardar' : 'Modificar',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, bool isEditing, Function(String) onChanged) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          color: isEditing ? Colors.blue : Colors.grey,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: isEditing ? Colors.white : Colors.white,
      ),
      style: TextStyle(
        color: isEditing ? Colors.black : Colors.grey.shade700,
      ),
      enabled: isEditing,
      onChanged: onChanged,
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      style: TextStyle(color: Colors.grey.shade700),
      enabled: false,
    );
  }
}