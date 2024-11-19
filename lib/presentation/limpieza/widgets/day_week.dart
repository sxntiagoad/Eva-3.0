import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/new_limpieza_provider.dart';

class DayWeek extends ConsumerWidget {
  final String category;
  final String day;
  final String dayValue;
  final bool? isMarked;

  const DayWeek({
    required this.category,
    required this.day,
    required this.dayValue,
    required this.isMarked,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(newLimpiezaProvider.notifier).updateDayOfWeek(
              category,
              dayValue,
              nextBoolDay(isMarked),
            );
      },
      child: CircleAvatar(
        radius: 18,
        backgroundColor: _colorDay(isMarked),
        child: Text(
          day,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

bool? nextBoolDay(bool? dayBool) {
  if (dayBool == null) return true;
  if (dayBool == true) return false;
  return null;
}

Color _colorDay(bool? day) {
  if (day == null) return Colors.grey;
  return day ? Colors.green : Colors.red;
}