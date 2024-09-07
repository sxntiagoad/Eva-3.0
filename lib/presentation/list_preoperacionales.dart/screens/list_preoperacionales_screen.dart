import 'package:eva/presentation/home/widgets/list_preoperacionales.dart';
import 'package:flutter/material.dart';

class ListPreoperacionalesScreen extends StatelessWidget {
  static const name = 'list-preoperacionales-screen';
  const ListPreoperacionalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preoperacinales'),),
      body: const ListPreoperacionales(),
    );
  }
}
