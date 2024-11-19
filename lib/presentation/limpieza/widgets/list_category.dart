import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/new_limpieza_provider.dart';
import 'card_category.dart';

class ListCategory extends ConsumerWidget {
  const ListCategory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final limpieza = ref.watch(newLimpiezaProvider);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      sliver: SliverToBoxAdapter(
        child: CardCategory(
          inspecciones: limpieza.inspecciones,
        ),
      ),
    );
  }
}