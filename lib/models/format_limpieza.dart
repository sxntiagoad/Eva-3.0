import 'package:eva/models/week.dart';

Map<String, Week> formatInspeccionesLimpieza() {
  return {
    'VOLANTE': Week(),
    'PALANCA DE CAMBIOS': Week(),
    'TABLERO': Week(),
    'ASIENTOS': Week(),
    'PISO': Week(),
    'VIDRIOS': Week(),
    'EXTERIOR': Week(),
  };
}