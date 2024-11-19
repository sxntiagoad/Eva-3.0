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

  String _getInstruccion(String category) {
    final instrucciones = {
      'VOLANTE': 'Limpiar con un trapo y solución Jabonosa',
      'PALANCA DE CAMBIOS': 'Limpiar con un trapo y solución Jabonosa',
      'PANEL DE MANDOS': 'Sacudir polvo y residuos.',
      'ESPEJO': 'Sacudir polvo y residuos.',
      'ASIENTO CONDUCTOR': 'Limpieza para eliminar impurezas sin alterar la composición del tejido.',
      'ASIENTO PASAJERO': 'Limpie para eliminar impurezas sin alterar la composición del tejido.',
      'MANIJAS INTERNAS PUERTAS DE PASAJERO': 'Pasar un paño por las puertas y sus marcas',
      'MANIJA INTERNA PUERTA DE CONDUCTOR': 'Pasar un paño por las puertas y sus marcas',
      'MANIJAS EXTERNAS PUERTAS DE PASAJERO': 'Pasar un paño por las puertas y sus marcas',
      'MANIJA EXTERNA PUERTA DE CONDUCTOR': 'Pasar un paño por las puertas y sus marcas',
      'SALPICADERO': 'Despejar de todo objeto(gafas, botellas, monedas) pasar un paño húmedo.',
      'VENTILACIÓN': 'Baja los vidrios, deje circular el aire de 3 a 5 minutos.',
      'TAPETE': 'Sacudir y pasar un cepillo',
      'CINTURON DE SEGURIDAD': 'Pasar un paño.',
    };
    return instrucciones[category] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título y categoría
            Row(
              children: [
                const Icon(
                  Icons.cleaning_services_outlined,
                  size: 24,
                  color: Colors.blue,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Instrucciones
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getInstruccion(category),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Días de la semana
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DayWeek(
                    category: category,
                    day: 'L',
                    dayValue: 'Lunes',
                    isMarked: week.lunes,
                  ),
                  const SizedBox(width: 8),
                  DayWeek(
                    category: category,
                    day: 'M',
                    dayValue: 'Martes',
                    isMarked: week.martes,
                  ),
                  const SizedBox(width: 8),
                  DayWeek(
                    category: category,
                    day: 'M',
                    dayValue: 'Miercoles',
                    isMarked: week.miercoles,
                  ),
                  const SizedBox(width: 8),
                  DayWeek(
                    category: category,
                    day: 'J',
                    dayValue: 'Jueves',
                    isMarked: week.jueves,
                  ),
                  const SizedBox(width: 8),
                  DayWeek(
                    category: category,
                    day: 'V',
                    dayValue: 'Viernes',
                    isMarked: week.viernes,
                  ),
                  const SizedBox(width: 8),
                  DayWeek(
                    category: category,
                    day: 'S',
                    dayValue: 'Sabado',
                    isMarked: week.sabado,
                  ),
                  const SizedBox(width: 8),
                  DayWeek(
                    category: category,
                    day: 'D',
                    dayValue: 'Domingo',
                    isMarked: week.domingo,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}