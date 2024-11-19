import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/week.dart';
import 'category_item.dart';

class CardCategory extends StatelessWidget {
  final Map<String, Week> inspecciones;
  
  const CardCategory({
    required this.inspecciones,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.mainColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...inspecciones.entries.map(
            (entry) => CategoryItem(
              category: entry.key,
              week: entry.value,
            ),
          ),
        ],
      ),
    );
  }
}