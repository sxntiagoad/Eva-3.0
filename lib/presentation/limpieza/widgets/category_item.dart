import 'package:flutter/material.dart';
import '../../../models/week.dart';
import 'day_week.dart';

class CategoryItem extends StatelessWidget {
  final String category;
  final Week week;

  const CategoryItem({
    super.key,
    required this.category,
    required this.week,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            category,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DayWeek(
                category: category,
                day: 'L',
                dayValue: 'Lunes',
                isMarked: week.lunes,
              ),
              DayWeek(
                category: category,
                day: 'M',
                dayValue: 'Martes',
                isMarked: week.martes,
              ),
              DayWeek(
                category: category,
                day: 'M',
                dayValue: 'Miercoles',
                isMarked: week.miercoles,
              ),
              DayWeek(
                category: category,
                day: 'J',
                dayValue: 'Jueves',
                isMarked: week.jueves,
              ),
              DayWeek(
                category: category,
                day: 'V',
                dayValue: 'Viernes',
                isMarked: week.viernes,
              ),
              DayWeek(
                category: category,
                day: 'S',
                dayValue: 'Sabado',
                isMarked: week.sabado,
              ),
              DayWeek(
                category: category,
                day: 'D',
                dayValue: 'Domingo',
                isMarked: week.domingo,
              ),
            ],
          )
        ],
      ),
    );
  }
}